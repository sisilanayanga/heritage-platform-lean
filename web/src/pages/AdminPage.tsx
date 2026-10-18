import {
  Alert, AlertIcon, Badge, Box, Button, Checkbox, FormControl, FormLabel, HStack, Input, Select, Stack, Tab, TabList, TabPanel, TabPanels, Table, Tbody, Td, Text, Textarea, Th, Thead, Tr, Tabs,
} from '@chakra-ui/react'
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { useState, type FormEvent } from 'react'
import { PageTitle, QueryState, fullName } from '../components/ui'
import { api, type PendingUser, type Person } from '../lib/api'

type Field = { key: string; label: string; type?: 'text' | 'textarea' | 'date' | 'checkbox' | 'select'; options?: string[]; required?: boolean }

function CreateForm({ endpoint, fields, invalidate, label }: { endpoint: string; fields: Field[]; invalidate: string[]; label: string }) {
  const qc = useQueryClient()
  const [values, setValues] = useState<Record<string, string | boolean>>({})
  const [msg, setMsg] = useState<{ ok: boolean; text: string } | null>(null)
  const m = useMutation({
    mutationFn: () => api(endpoint, { method: 'POST', body: values }),
    onSuccess: () => {
      setValues({})
      setMsg({ ok: true, text: 'Saved.' })
      invalidate.forEach((k) => void qc.invalidateQueries({ queryKey: [k] }))
    },
    onError: (e) => setMsg({ ok: false, text: e instanceof Error ? e.message : 'Failed' }),
  })
  const submit = (e: FormEvent) => {
    e.preventDefault()
    m.mutate()
  }
  return (
    <Stack as="form" onSubmit={submit} spacing={3} bg="white" p={5} rounded="lg" shadow="sm" maxW="2xl">
      {msg && <Alert status={msg.ok ? 'success' : 'error'}><AlertIcon />{msg.text}</Alert>}
      {fields.map((f) => (
        <FormControl key={f.key} isRequired={f.required}>
          {f.type === 'checkbox' ? (
            <Checkbox isChecked={!!values[f.key]} onChange={(e) => setValues({ ...values, [f.key]: e.target.checked })}>{f.label}</Checkbox>
          ) : (
            <>
              <FormLabel>{f.label}</FormLabel>
              {f.type === 'textarea' ? (
                <Textarea value={(values[f.key] as string) ?? ''} onChange={(e) => setValues({ ...values, [f.key]: e.target.value })} />
              ) : f.type === 'select' ? (
                <Select placeholder="Select" value={(values[f.key] as string) ?? ''} onChange={(e) => setValues({ ...values, [f.key]: e.target.value })}>
                  {f.options?.map((o) => <option key={o}>{o}</option>)}
                </Select>
              ) : (
                <Input type={f.type === 'date' ? 'date' : 'text'} value={(values[f.key] as string) ?? ''} onChange={(e) => setValues({ ...values, [f.key]: e.target.value })} />
              )}
            </>
          )}
        </FormControl>
      ))}
      <Button type="submit" colorScheme="orange" isLoading={m.isPending} alignSelf="start">{label}</Button>
    </Stack>
  )
}

function Registrations() {
  const qc = useQueryClient()
  const { data, isLoading, error } = useQuery({ queryKey: ['admin-users'], queryFn: () => api<PendingUser[]>('admin/users') })
  const act = useMutation({
    mutationFn: ({ id, action }: { id: number; action: 'approve' | 'reject' }) => api(`admin/users/${id}/${action}`, { method: 'POST' }),
    onSuccess: () => void qc.invalidateQueries({ queryKey: ['admin-users'] }),
  })
  return (
    <>
      <QueryState loading={isLoading} error={error ?? act.error} />
      <Box overflowX="auto" bg="white" rounded="lg" shadow="sm">
        <Table size="sm">
          <Thead><Tr><Th>Name</Th><Th>Email</Th><Th>Relationship</Th><Th>Status</Th><Th /></Tr></Thead>
          <Tbody>
            {data?.map((u) => (
              <Tr key={u.id}>
                <Td>{u.full_name}</Td>
                <Td>{u.email}</Td>
                <Td maxW="xs" whiteSpace="normal">{u.relationship_note}</Td>
                <Td><Badge colorScheme={u.status === 'approved' ? 'green' : u.status === 'pending' ? 'orange' : 'red'}>{u.status}</Badge></Td>
                <Td>
                  {u.status !== 'approved' && <Button size="xs" colorScheme="green" mr={2} onClick={() => act.mutate({ id: u.id, action: 'approve' })}>Approve</Button>}
                  {u.status === 'pending' && <Button size="xs" colorScheme="red" variant="outline" onClick={() => act.mutate({ id: u.id, action: 'reject' })}>Reject</Button>}
                </Td>
              </Tr>
            ))}
          </Tbody>
        </Table>
      </Box>
    </>
  )
}

function RelationshipForm() {
  const people = useQuery({ queryKey: ['people'], queryFn: () => api<Person[]>('people') })
  const qc = useQueryClient()
  const [v, setV] = useState({ personId: '', relatedPersonId: '', type: 'parent_of' })
  const m = useMutation({
    mutationFn: () => api('admin/relationships', { method: 'POST', body: { ...v, personId: Number(v.personId), relatedPersonId: Number(v.relatedPersonId) } }),
    onSuccess: () => void qc.invalidateQueries({ queryKey: ['tree'] }),
  })
  const opts = people.data?.filter((p) => !Number(p.removed)).map((p) => <option key={p.id} value={p.id}>{fullName(p)}</option>)
  return (
    <Stack spacing={3} bg="white" p={5} rounded="lg" shadow="sm" maxW="2xl">
      <Text fontWeight="semibold">Link two people</Text>
      {m.error && <Alert status="error"><AlertIcon />{m.error.message}</Alert>}
      {m.isSuccess && <Alert status="success"><AlertIcon />Linked.</Alert>}
      <HStack wrap="wrap">
        <Select placeholder="Person" w="auto" value={v.personId} onChange={(e) => setV({ ...v, personId: e.target.value })}>{opts}</Select>
        <Select w="auto" value={v.type} onChange={(e) => setV({ ...v, type: e.target.value })}>
          <option value="parent_of">is parent of</option>
          <option value="spouse_of">is spouse of</option>
        </Select>
        <Select placeholder="Related person" w="auto" value={v.relatedPersonId} onChange={(e) => setV({ ...v, relatedPersonId: e.target.value })}>{opts}</Select>
      </HStack>
      <Button alignSelf="start" colorScheme="orange" isDisabled={!v.personId || !v.relatedPersonId} onClick={() => m.mutate()}>Save link</Button>
    </Stack>
  )
}

function PageEditor() {
  const [slug, setSlug] = useState('history')
  const { data } = useQuery({ queryKey: ['page', slug], queryFn: () => api<{ title: string; body: string }>(`pages/${slug}`) })
  const qc = useQueryClient()
  const [draft, setDraft] = useState<{ slug: string; title: string; body: string } | null>(null)
  const current = draft?.slug === slug ? draft : data ? { slug, ...data } : { slug, title: '', body: '' }
  const m = useMutation({
    mutationFn: () => api(`admin/pages/${slug}`, { method: 'PUT', body: { title: current.title, body: current.body } }),
    onSuccess: () => void qc.invalidateQueries({ queryKey: ['page', slug] }),
  })
  return (
    <Stack spacing={3} bg="white" p={5} rounded="lg" shadow="sm" maxW="3xl">
      <Select value={slug} onChange={(e) => { setSlug(e.target.value); setDraft(null) }} w="auto">
        <option value="history">History</option>
        <option value="izithakazelo">Izithakazelo</option>
        <option value="culture">Culture</option>
      </Select>
      {m.error && <Alert status="error"><AlertIcon />{m.error.message}</Alert>}
      {m.isSuccess && <Alert status="success"><AlertIcon />Saved.</Alert>}
      <Input value={current.title} onChange={(e) => setDraft({ ...current, title: e.target.value })} />
      <Textarea minH="64" value={current.body} onChange={(e) => setDraft({ ...current, body: e.target.value })} />
      <Button alignSelf="start" colorScheme="orange" isLoading={m.isPending} isDisabled={!current.title || !current.body} onClick={() => m.mutate()}>Save page</Button>
    </Stack>
  )
}

export function AdminPage() {
  return (
    <>
      <PageTitle sub="Approve members and manage clan content">Admin</PageTitle>
      <Tabs colorScheme="orange" isLazy>
        <TabList overflowX="auto">
          <Tab>Registrations</Tab><Tab>Announcements</Tab><Tab>People</Tab><Tab>Stories</Tab><Tab>Events</Tab><Tab>Places</Tab><Tab>Pages</Tab>
        </TabList>
        <TabPanels>
          <TabPanel px={0}><Registrations /></TabPanel>
          <TabPanel px={0}>
            <CreateForm endpoint="admin/announcements" label="Publish" invalidate={['announcements']} fields={[
              { key: 'title', label: 'Title', required: true }, { key: 'body', label: 'Message', type: 'textarea', required: true }, { key: 'is_public', label: 'Visible to guests', type: 'checkbox' },
            ]} />
          </TabPanel>
          <TabPanel px={0}>
            <Stack spacing={6}>
              <CreateForm endpoint="admin/people" label="Add person" invalidate={['people', 'tree']} fields={[
                { key: 'given_name', label: 'Given name', required: true }, { key: 'family_name', label: 'Family name' }, { key: 'clan_name', label: 'Clan name (isithakazelo)' },
                { key: 'gender', label: 'Gender', type: 'select', options: ['male', 'female', 'other'] },
                { key: 'birth_date', label: 'Birth date', type: 'date' }, { key: 'death_date', label: 'Death date', type: 'date' },
                { key: 'is_living', label: 'Is living', type: 'checkbox' }, { key: 'birth_place', label: 'Birth place' }, { key: 'bio', label: 'Biography', type: 'textarea' },
              ]} />
              <RelationshipForm />
            </Stack>
          </TabPanel>
          <TabPanel px={0}>
            <CreateForm endpoint="admin/stories" label="Add story" invalidate={['stories']} fields={[
              { key: 'title', label: 'Title', required: true }, { key: 'narrator', label: 'Narrator' }, { key: 'body', label: 'Story', type: 'textarea', required: true },
            ]} />
          </TabPanel>
          <TabPanel px={0}>
            <CreateForm endpoint="admin/events" label="Add event" invalidate={['events']} fields={[
              { key: 'title', label: 'Title', required: true }, { key: 'kind', label: 'Kind (e.g. umembeso, imbeleko, reunion)' }, { key: 'event_date', label: 'Date', type: 'date' },
              { key: 'location', label: 'Location' }, { key: 'details', label: 'Details', type: 'textarea' },
            ]} />
          </TabPanel>
          <TabPanel px={0}>
            <CreateForm endpoint="admin/places" label="Add place" invalidate={['places']} fields={[
              { key: 'name', label: 'Name', required: true }, { key: 'kind', label: 'Kind', type: 'select', options: ['homestead', 'grave', 'origin', 'other'] },
              { key: 'description', label: 'Description', type: 'textarea' }, { key: 'latitude', label: 'Latitude' }, { key: 'longitude', label: 'Longitude' },
            ]} />
          </TabPanel>
          <TabPanel px={0}><PageEditor /></TabPanel>
        </TabPanels>
      </Tabs>
    </>
  )
}
