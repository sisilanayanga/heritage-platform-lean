import { Box, Button, HStack, IconButton, Link, Text, VStack } from '@chakra-ui/react'
import { useQuery } from '@tanstack/react-query'
import { useMemo, useState } from 'react'
import { Link as RouterLink, useSearchParams } from 'react-router-dom'
import { PageTitle, QueryState, fmtDate, fullName } from '../components/ui'
import { api, type Person, type Relationship } from '../lib/api'

interface Node { person: Person; spouses: Person[]; children: Node[] }

function buildIndex(people: Person[], rels: Relationship[]) {
  const byId = new Map(people.map((p) => [Number(p.id), p]))
  const childrenOf = new Map<number, number[]>()
  const parentsOf = new Map<number, number[]>()
  const spousesOf = new Map<number, number[]>()
  const add = (m: Map<number, number[]>, k: number, v: number) => m.set(k, [...(m.get(k) ?? []), v])

  for (const r of rels) {
    const a = Number(r.person_id)
    const b = Number(r.related_person_id)
    if (r.type === 'parent_of') {
      add(childrenOf, a, b)
      add(parentsOf, b, a)
    } else {
      add(spousesOf, a, b)
      add(spousesOf, b, a)
    }
  }

  const makeNode = (id: number, seen: Set<number>): Node | null => {
    const person = byId.get(id)
    if (!person || seen.has(id)) return null
    seen.add(id)
    const spouses = (spousesOf.get(id) ?? []).map((s) => byId.get(s)).filter((s): s is Person => !!s)
    spouses.forEach((s) => seen.add(Number(s.id)))
    const kids = new Set([id, ...spouses.map((s) => Number(s.id))].flatMap((x) => childrenOf.get(x) ?? []))
    const children = [...kids].map((k) => makeNode(k, seen)).filter((n): n is Node => n !== null)
    return { person, spouses, children }
  }

  const roots = () => {
    const seen = new Set<number>()
    return people
      .filter((p) => !parentsOf.has(Number(p.id)))
      .map((p) => makeNode(Number(p.id), seen))
      .filter((n): n is Node => n !== null)
  }

  // Ancestors as generations, oldest first; each generation holds the parents of the one below.
  const ancestors = (id: number): Person[][] => {
    const gens: Person[][] = []
    const seen = new Set<number>([id])
    let current = [id]
    while (current.length) {
      const next = [...new Set(current.flatMap((c) => parentsOf.get(c) ?? []))].filter((x) => !seen.has(x))
      next.forEach((x) => seen.add(x))
      const ps = next.map((x) => byId.get(x)).filter((x): x is Person => !!x)
      if (ps.length) gens.unshift(ps)
      current = next
    }
    return gens
  }

  return { byId, roots, makeNode, ancestors }
}
function Card({ p, focused = false, defaultOpen }: { p: Person; focused?: boolean; defaultOpen: boolean }) {
  const [open, setOpen] = useState(defaultOpen)
  const tone = p.gender === 'male' ? 'blue' : p.gender === 'female' ? 'pink' : 'gray'
  return (
    <Box
      bg={`${tone}.50`}
      borderWidth="1px"
      borderColor={`${tone}.300`}
      borderLeftWidth="4px"
      borderLeftColor={`${tone}.500`}
      rounded="md"
      px={2}
      py={1}
      outline={focused ? '2px solid' : undefined}
      outlineColor={`${tone}.500`}
    >
      <HStack spacing={1} align="center">
        <IconButton
          aria-label={open ? 'Collapse' : 'Expand'}
          icon={<Text as="span">{open ? '▾' : '▸'}</Text>}
          size="xs"
          variant="ghost"
          minW={5}
          h={5}
          onClick={() => setOpen((o) => !o)}
        />
        <Link as={RouterLink} to={`/people/${p.id}`} fontWeight="semibold" fontSize="sm" color="brand.700" whiteSpace="nowrap">{fullName(p)}</Link>
      </HStack>
      {open && (
        <Box pl={6}>
          {!p.restricted && (
            <Text fontSize="xs" color="gray.600">
              {fmtDate(p.birth_date) || '?'} – {Number(p.is_living) ? 'living' : fmtDate(p.death_date) || '?'}
            </Text>
          )}
          {!focused && (
            <Link as={RouterLink} to={`/family-tree?focus=${p.id}`} fontSize="xs" color="gray.600" textDecoration="underline">
              Focus
            </Link>
          )}
        </Box>
      )}
    </Box>
  )
}

function countDescendants(n: Node): number {
  return n.children.reduce((s, c) => s + 1 + countDescendants(c), 0)
}

function TreeNode({ node, focusId, defaultOpen }: { node: Node; focusId?: number | null; defaultOpen: boolean }) {
  const [showKids, setShowKids] = useState(true)
  const hasKids = node.children.length > 0
  return (
    <VStack align="stretch" spacing={1}>
      <HStack wrap="wrap" spacing={1} align="center">
        {hasKids && (
          <Button size="xs" variant="outline" h={6} px={2} onClick={() => setShowKids((s) => !s)} title={showKids ? 'Hide descendants' : 'Show descendants'}>
            {showKids ? '−' : `+${countDescendants(node)}`}
          </Button>
        )}
        <Card p={node.person} focused={Number(node.person.id) === focusId} defaultOpen={defaultOpen} />
        {node.spouses.map((s) => (
          <HStack key={s.id} spacing={1}><Text color="brand.500">⚭</Text><Card p={s} focused={Number(s.id) === focusId} defaultOpen={defaultOpen} /></HStack>
        ))}
      </HStack>
      {hasKids && showKids && (
        <VStack align="stretch" spacing={1} pl={{ base: 3, md: 5 }} ml={2} borderLeft="2px solid" borderColor="brand.200">
          {node.children.map((c) => <TreeNode key={c.person.id} node={c} focusId={focusId} defaultOpen={defaultOpen} />)}
        </VStack>
      )}
    </VStack>
  )
}
export function FamilyTreePage() {
  const { data, isLoading, error } = useQuery({ queryKey: ['tree'], queryFn: () => api<{ people: Person[]; relationships: Relationship[] }>('tree') })
  const [params] = useSearchParams()
  const focusId = Number(params.get('focus')) || null
  const [mode, setMode] = useState({ open: false, v: 0 })
  const index = useMemo(() => (data ? buildIndex(data.people, data.relationships) : null), [data])

  const roots = useMemo(() => (index && !focusId ? index.roots() : []), [index, focusId])
  const focus = useMemo(() => {
    if (!index || !focusId) return null
    const node = index.makeNode(focusId, new Set())
    return node ? { node, ancestors: index.ancestors(focusId) } : null
  }, [index, focusId])

  return (
    <>
      <PageTitle sub="Descendants are shown under their parents; ⚭ marks a spouse. Use Focus on a person to see only their lineage and descendants.">Family Tree</PageTitle>
      <HStack mb={3} spacing={2}>
        <Button size="xs" onClick={() => setMode((m) => ({ open: true, v: m.v + 1 }))}>Expand all</Button>
        <Button size="xs" onClick={() => setMode((m) => ({ open: false, v: m.v + 1 }))}>Collapse all</Button>
      </HStack>
      <QueryState loading={isLoading} error={error} />
      {data && !focusId && roots.length === 0 && <Text>No people recorded yet.</Text>}
      {focusId && data && !focus && <Text>Person not found.</Text>}
      {focusId && focus && (
        <VStack align="stretch" spacing={4} mb={4}>
          <Button as={RouterLink} to="/family-tree" size="sm" alignSelf="flex-start" variant="outline">← Show full tree</Button>
          {focus.ancestors.length > 0 && (
            <Box>
              <Text fontWeight="semibold" mb={2}>Lineage (ancestors)</Text>
              <VStack align="stretch" spacing={2}>
                {focus.ancestors.map((gen, i) => (
                  <HStack key={i} wrap="wrap" spacing={2}>
                    {gen.map((p) => <Card key={`${p.id}-${mode.v}`} p={p} defaultOpen={mode.open} />)}
                    <Text color="brand.500">↓</Text>
                  </HStack>
                ))}
              </VStack>
            </Box>
          )}
          <Text fontWeight="semibold">{fullName(focus.node.person)} and descendants</Text>
        </VStack>
      )}
      <VStack align="stretch" spacing={4} overflowX="auto">
        {focus ? <TreeNode key={mode.v} node={focus.node} focusId={focusId} defaultOpen={mode.open} /> : roots.map((r) => <TreeNode key={`${r.person.id}-${mode.v}`} node={r} defaultOpen={mode.open} />)}
      </VStack>
    </>
  )
}



