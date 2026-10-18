import {
  Badge, Box, Button, FormControl, FormLabel, Heading, HStack, Input, Link, Select, Stack, Text, Textarea, Wrap, Alert, AlertIcon,
} from '@chakra-ui/react'
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { useState } from 'react'
import { Link as RouterLink, useParams } from 'react-router-dom'
import { useAuth } from '../auth/AuthContext'
import { PageTitle, QueryState } from '../components/ui'
import { api, type Evidence, type Story } from '../lib/api'

const EVIDENCE: Record<Evidence, { label: string; color: string }> = {
  verified: { label: 'Source found', color: 'green' },
  oral: { label: 'Oral / traditional', color: 'purple' },
  unconfirmed: { label: 'To be confirmed', color: 'orange' },
}

export function EvidenceBadge({ status }: { status: Evidence }) {
  const e = EVIDENCE[status] ?? EVIDENCE.unconfirmed
  return <Badge colorScheme={e.color}>{e.label}</Badge>
}

// Sources are stored one per line as "Label | URL"; only http(s) links are rendered as links.
function parseSources(raw?: string | null) {
  return (raw ?? '').split('\n').map((l) => l.trim()).filter(Boolean).map((l) => {
    const [label, url] = l.includes('|') ? l.split('|').map((s) => s.trim()) : [l, '']
    return { label, url: /^https?:\/\//i.test(url) ? url : '' }
  })
}

type Sort = 'popular' | 'newest' | 'oldest'
const PAGE_SIZE = 10

export function StoriesPage() {
  const { can } = useAuth()
  const { data, isLoading, error } = useQuery({ queryKey: ['stories'], queryFn: () => api<Story[]>('stories') })
  const [sort, setSort] = useState<Sort>('newest')
  const [category, setCategory] = useState('')
  const [q, setQ] = useState('')
  const [page, setPage] = useState(1)

  const categories = [...new Set((data ?? []).map((s) => s.category).filter((c): c is string => !!c))].sort()
  const key = (s: Story) => s.event_date ?? s.created_at.slice(0, 10)
  const filtered = (data ?? [])
    .filter((s) => (!category || s.category === category) && `${s.title} ${s.summary ?? ''}`.toLowerCase().includes(q.trim().toLowerCase()))
    .sort((a, b) => (sort === 'popular' ? Number(b.view_count) - Number(a.view_count) : sort === 'newest' ? key(b).localeCompare(key(a)) : key(a).localeCompare(key(b))))
  const pages = Math.max(1, Math.ceil(filtered.length / PAGE_SIZE))
  const current = Math.min(page, pages)
  const shown = filtered.slice((current - 1) * PAGE_SIZE, current * PAGE_SIZE)

  return (
    <>
      <PageTitle sub="Articles, oral history and research, with the evidence behind each one">Stories</PageTitle>
      <HStack wrap="wrap" spacing={3} mb={4} align="end">
        <Input bg="white" maxW="xs" placeholder="Search articles" value={q} onChange={(e) => { setQ(e.target.value); setPage(1) }} />
        <Select bg="white" maxW="xs" value={category} onChange={(e) => { setCategory(e.target.value); setPage(1) }}>
          <option value="">All categories</option>
          {categories.map((c) => <option key={c}>{c}</option>)}
        </Select>
        <Select bg="white" maxW="xs" value={sort} onChange={(e) => setSort(e.target.value as Sort)}>
          <option value="newest">Newest events first</option>
          <option value="oldest">Oldest first (timeline)</option>
          <option value="popular">Most read</option>
        </Select>
        {can('stories.manage') && <Button as={RouterLink} to="/admin" size="sm" colorScheme="orange" variant="outline">Add article</Button>}
      </HStack>
      <QueryState loading={isLoading} error={error} />
      {data && filtered.length === 0 && <Text>No articles found.</Text>}
      <Stack spacing={3}>
        {shown.map((s) => (
          <Box key={s.id} bg="white" p={5} rounded="lg" shadow="sm" borderLeft="4px solid" borderColor={`${(EVIDENCE[s.evidence_status] ?? EVIDENCE.unconfirmed).color}.400`}>
            <Wrap spacing={2} mb={1}>
              {s.date_label && <Badge colorScheme="blue">{s.date_label}</Badge>}
              {s.category && <Badge>{s.category}</Badge>}
              <EvidenceBadge status={s.evidence_status} />
            </Wrap>
            <Heading size="md"><Link as={RouterLink} to={`/stories/${s.id}`} color="brand.700">{s.title}</Link></Heading>
            {s.summary && <Text mt={1}>{s.summary}</Text>}
            <Text fontSize="xs" color="gray.500" mt={2}>{Number(s.view_count)} read{Number(s.view_count) === 1 ? '' : 's'}{s.narrator ? ` · ${s.narrator}` : ''}</Text>
          </Box>
        ))}
      </Stack>
      {filtered.length > PAGE_SIZE && (
        <HStack mt={4} justify="center" spacing={3}>
          <Button size="sm" isDisabled={current <= 1} onClick={() => setPage(current - 1)}>Previous</Button>
          <Text fontSize="sm">Page {current} of {pages}</Text>
          <Button size="sm" isDisabled={current >= pages} onClick={() => setPage(current + 1)}>Next</Button>
        </HStack>
      )}
    </>
  )
}

function StoryEditForm({ story, onDone }: { story: Story; onDone: () => void }) {
  const qc = useQueryClient()
  const [v, setV] = useState({
    title: story.title, summary: story.summary ?? '', category: story.category ?? '', event_date: (story.event_date ?? '').slice(0, 10),
    date_label: story.date_label ?? '', evidence_status: story.evidence_status, narrator: story.narrator ?? '', body: story.body ?? '', sources: story.sources ?? '',
  })
  const set = (k: keyof typeof v) => (e: { target: { value: string } }) => setV({ ...v, [k]: e.target.value })
  const save = useMutation({
    mutationFn: () => api(`admin/stories/${story.id}`, { method: 'PUT', body: v }),
    onSuccess: async () => {
      await Promise.all(['story', 'stories', 'story-highlights'].map((k) => qc.invalidateQueries({ queryKey: [k] })))
      onDone()
    },
  })
  return (
    <Stack spacing={3}>
      {save.error && <Alert status="error"><AlertIcon />{save.error.message}</Alert>}
      <FormControl isRequired><FormLabel>Title</FormLabel><Input value={v.title} onChange={set('title')} /></FormControl>
      <FormControl><FormLabel>Summary (shown in lists)</FormLabel><Input value={v.summary} onChange={set('summary')} /></FormControl>
      <HStack align="end" wrap="wrap">
        <FormControl maxW="xs"><FormLabel>Category</FormLabel><Input value={v.category} onChange={set('category')} /></FormControl>
        <FormControl maxW="xs"><FormLabel>Date (for ordering)</FormLabel><Input type="date" value={v.event_date} onChange={set('event_date')} /></FormControl>
        <FormControl maxW="xs"><FormLabel>Date as shown</FormLabel><Input value={v.date_label} onChange={set('date_label')} placeholder="e.g. c. 1825" /></FormControl>
        <FormControl maxW="xs"><FormLabel>Evidence</FormLabel>
          <Select value={v.evidence_status} onChange={set('evidence_status')}>
            {Object.entries(EVIDENCE).map(([k, e]) => <option key={k} value={k}>{e.label}</option>)}
          </Select>
        </FormControl>
      </HStack>
      <FormControl><FormLabel>Told by / author</FormLabel><Input value={v.narrator} onChange={set('narrator')} /></FormControl>
      <FormControl isRequired><FormLabel>Article</FormLabel><Textarea minH="48" value={v.body} onChange={set('body')} /></FormControl>
      <FormControl><FormLabel>Sources (one per line: Label | https://link)</FormLabel><Textarea value={v.sources} onChange={set('sources')} /></FormControl>
      <HStack>
        <Button colorScheme="orange" onClick={() => save.mutate()} isLoading={save.isPending} isDisabled={!v.title.trim() || !v.body.trim()}>Save</Button>
        <Button variant="ghost" onClick={onDone}>Cancel</Button>
      </HStack>
    </Stack>
  )
}

export function StoryPage() {
  const { id } = useParams()
  const { can } = useAuth()
  const [editing, setEditing] = useState(false)
  const { data, isLoading, error } = useQuery({ queryKey: ['story', id], queryFn: () => api<Story>(`stories/${id}`) })
  const sources = parseSources(data?.sources)
  return (
    <>
      <QueryState loading={isLoading} error={error} />
      {data && (
        <Box bg="white" p={{ base: 5, md: 8 }} rounded="lg" shadow="sm">
          {editing ? (
            <StoryEditForm story={data} onDone={() => setEditing(false)} />
          ) : (
            <>
              <Wrap spacing={2} mb={2}>
                {data.date_label && <Badge colorScheme="blue">{data.date_label}</Badge>}
                {data.category && <Badge>{data.category}</Badge>}
                <EvidenceBadge status={data.evidence_status} />
              </Wrap>
              <HStack justify="space-between" align="start">
                <Heading color="brand.800">{data.title}</Heading>
                {can('stories.manage') && <Button size="sm" colorScheme="orange" onClick={() => setEditing(true)}>Edit</Button>}
              </HStack>
              <Text fontSize="sm" color="gray.500" mt={1}>{Number(data.view_count)} read{Number(data.view_count) === 1 ? '' : 's'}{data.narrator ? ` · ${data.narrator}` : ''}</Text>
              {data.evidence_status !== 'verified' && (
                <Alert status="warning" rounded="md" mt={4}><AlertIcon />This article is {data.evidence_status === 'oral' ? 'traditional or oral history' : 'not yet confirmed'}. Treat it as a lead for further research, not as settled fact.</Alert>
              )}
              <Text mt={4} whiteSpace="pre-wrap" lineHeight="tall">{data.body}</Text>
              {sources.length > 0 && (
                <Box mt={6}>
                  <Heading size="sm" mb={2}>Sources</Heading>
                  <Stack as="ul" pl={5} spacing={1}>
                    {sources.map((s, i) => (
                      <li key={i}>{s.url ? <Link href={s.url} isExternal color="brand.600">{s.label}</Link> : s.label}</li>
                    ))}
                  </Stack>
                </Box>
              )}
            </>
          )}
          <Link as={RouterLink} to="/stories" color="brand.600" display="block" mt={6}>← All stories</Link>
        </Box>
      )}
    </>
  )
}
