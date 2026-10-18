import { Box, HStack, Link, Text, VStack } from '@chakra-ui/react'
import { useQuery } from '@tanstack/react-query'
import { useMemo } from 'react'
import { Link as RouterLink } from 'react-router-dom'
import { PageTitle, QueryState, fmtDate, fullName } from '../components/ui'
import { api, type Person, type Relationship } from '../lib/api'

interface Node { person: Person; spouses: Person[]; children: Node[] }

function buildTree(people: Person[], rels: Relationship[]): Node[] {
  const byId = new Map(people.map((p) => [p.id, p]))
  const childrenOf = new Map<number, number[]>()
  const spousesOf = new Map<number, number[]>()
  const hasParent = new Set<number>()
  const add = (m: Map<number, number[]>, k: number, v: number) => m.set(k, [...(m.get(k) ?? []), v])

  for (const r of rels) {
    const a = Number(r.person_id)
    const b = Number(r.related_person_id)
    if (r.type === 'parent_of') {
      add(childrenOf, a, b)
      hasParent.add(b)
    } else {
      add(spousesOf, a, b)
      add(spousesOf, b, a)
    }
  }

  const seen = new Set<number>()
  const make = (id: number): Node | null => {
    const person = byId.get(id)
    if (!person || seen.has(id)) return null
    seen.add(id)
    const spouses = (spousesOf.get(id) ?? []).map((s) => byId.get(s)).filter((s): s is Person => !!s)
    spouses.forEach((s) => seen.add(Number(s.id)))
    const kids = new Set([id, ...spouses.map((s) => Number(s.id))].flatMap((x) => childrenOf.get(x) ?? []))
    const children = [...kids].map(make).filter((n): n is Node => n !== null)
    return { person, spouses, children }
  }

  return people
    .filter((p) => !hasParent.has(Number(p.id)))
    .map((p) => make(Number(p.id)))
    .filter((n): n is Node => n !== null)
}

function Card({ p }: { p: Person }) {
  return (
    <Box bg="white" borderWidth="1px" borderColor="brand.300" rounded="md" px={3} py={2} minW="40">
      <Link as={RouterLink} to={`/people/${p.id}`} fontWeight="semibold" color="brand.700">{fullName(p)}</Link>
      <Text fontSize="xs" color="gray.600">
        {fmtDate(p.birth_date) || '?'} – {Number(p.is_living) ? 'living' : fmtDate(p.death_date) || '?'}
      </Text>
    </Box>
  )
}

function TreeNode({ node }: { node: Node }) {
  return (
    <VStack align="stretch" spacing={2}>
      <HStack wrap="wrap" spacing={2}>
        <Card p={node.person} />
        {node.spouses.map((s) => (
          <HStack key={s.id} spacing={2}><Text color="brand.500">⚭</Text><Card p={s} /></HStack>
        ))}
      </HStack>
      {node.children.length > 0 && (
        <VStack align="stretch" spacing={3} pl={{ base: 4, md: 8 }} borderLeft="2px solid" borderColor="brand.200">
          {node.children.map((c) => <TreeNode key={c.person.id} node={c} />)}
        </VStack>
      )}
    </VStack>
  )
}

export function FamilyTreePage() {
  const { data, isLoading, error } = useQuery({ queryKey: ['tree'], queryFn: () => api<{ people: Person[]; relationships: Relationship[] }>('tree') })
  const roots = useMemo(() => (data ? buildTree(data.people, data.relationships) : []), [data])

  return (
    <>
      <PageTitle sub="Descendants are shown under their parents; ⚭ marks a spouse.">Family Tree</PageTitle>
      <QueryState loading={isLoading} error={error} />
      {data && roots.length === 0 && <Text>No people recorded yet.</Text>}
      <VStack align="stretch" spacing={8} overflowX="auto">
        {roots.map((r) => <TreeNode key={r.person.id} node={r} />)}
      </VStack>
    </>
  )
}
