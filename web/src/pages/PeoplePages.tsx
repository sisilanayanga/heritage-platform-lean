import { Alert, AlertIcon, Badge, Box, Button, Checkbox, FormControl, FormLabel, Heading, HStack, Input, Link, Select, SimpleGrid, Stack, Text, Textarea } from '@chakra-ui/react'
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { useState, type FormEvent } from 'react'
import { Link as RouterLink, useParams } from 'react-router-dom'
import { useAuth } from '../auth/AuthContext'
import { PageTitle, QueryState, fmtDate, fullName } from '../components/ui'
import { api, type Person } from '../lib/api'

function PersonEditForm({ person, onDone }: { person: Person; onDone: () => void }) {
  const qc = useQueryClient()
  const [v, setV] = useState({
    given_name: person.given_name,
    family_name: person.family_name ?? '',
    clan_name: person.clan_name ?? '',
    gender: person.gender ?? '',
    birth_date: fmtDate(person.birth_date),
    death_date: fmtDate(person.death_date),
    is_living: !!Number(person.is_living),
    birth_place: person.birth_place ?? '',
    bio: person.bio ?? '',
  })
  const set = (k: keyof typeof v) => (e: { target: { value: string } }) => setV({ ...v, [k]: e.target.value })
  const m = useMutation({
    mutationFn: () => api(`admin/people/${person.id}`, { method: 'PUT', body: v }),
    onSuccess: async () => {
      await Promise.all(['person', 'people', 'tree'].map((k) => qc.invalidateQueries({ queryKey: [k] })))
      onDone()
    },
  })
  const submit = (e: FormEvent) => {
    e.preventDefault()
    m.mutate()
  }
  return (
    <Stack as="form" onSubmit={submit} spacing={3}>
      {m.error && <Alert status="error"><AlertIcon />{m.error.message}</Alert>}
      <FormControl isRequired><FormLabel>Given name</FormLabel><Input value={v.given_name} onChange={set('given_name')} /></FormControl>
      <FormControl><FormLabel>Family name</FormLabel><Input value={v.family_name} onChange={set('family_name')} /></FormControl>
      <FormControl><FormLabel>Clan name (isiduko)</FormLabel><Input value={v.clan_name} onChange={set('clan_name')} /></FormControl>
      <FormControl>
        <FormLabel>Gender</FormLabel>
        <Select placeholder="Select" value={v.gender} onChange={set('gender')}>
          <option value="male">male</option><option value="female">female</option><option value="other">other</option>
        </Select>
      </FormControl>
      <FormControl><FormLabel>Birth date</FormLabel><Input type="date" value={v.birth_date} onChange={set('birth_date')} /></FormControl>
      <FormControl><FormLabel>Death date</FormLabel><Input type="date" value={v.death_date} onChange={set('death_date')} /></FormControl>
      <Checkbox isChecked={v.is_living} onChange={(e) => setV({ ...v, is_living: e.target.checked })}>Is living</Checkbox>
      <FormControl><FormLabel>Birth place</FormLabel><Input value={v.birth_place} onChange={set('birth_place')} /></FormControl>
      <FormControl><FormLabel>Biography</FormLabel><Textarea minH="32" value={v.bio} onChange={set('bio')} /></FormControl>
      <HStack>
        <Button type="submit" colorScheme="orange" isLoading={m.isPending}>Save changes</Button>
        <Button variant="ghost" onClick={onDone}>Cancel</Button>
      </HStack>
    </Stack>
  )
}

export function PeoplePage() {
  const { data, isLoading, error } = useQuery({ queryKey: ['people'], queryFn: () => api<Person[]>('people') })
  return (
    <>
      <PageTitle sub="Everyone recorded in the clan archive">People</PageTitle>
      <QueryState loading={isLoading} error={error} />
      <SimpleGrid columns={{ base: 1, sm: 2, lg: 3 }} spacing={3}>
        {data?.map((p) => (
          <Box key={p.id} bg="white" p={4} rounded="md" shadow="sm" opacity={Number(p.removed) ? 0.6 : 1}>
            <Link as={RouterLink} to={`/people/${p.id}`} fontWeight="semibold" color="brand.700">{fullName(p)}</Link>
            {!!Number(p.removed) && <Badge ml={2} colorScheme="red">Disabled</Badge>}
            {p.clan_name && <Text fontSize="sm">Clan name: {p.clan_name}</Text>}
            <Text fontSize="xs" color="gray.600">{fmtDate(p.birth_date) || '?'} – {Number(p.is_living) ? 'living' : fmtDate(p.death_date) || '?'}</Text>
          </Box>
        ))}
      </SimpleGrid>
    </>
  )
}

export function PersonPage() {
  const { id } = useParams()
  const { user } = useAuth()
  const [editing, setEditing] = useState(false)
  const qc = useQueryClient()
  const { data, isLoading, error } = useQuery({ queryKey: ['person', id], queryFn: () => api<Person>(`people/${id}`) })
  const isRemoved = !!Number(data?.removed)
  const toggle = useMutation({
    mutationFn: () => api(`admin/people/${id}/${isRemoved ? 'restore' : 'disable'}`, { method: 'POST' }),
    onSuccess: async () => {
      await Promise.all(['person', 'people', 'tree'].map((k) => qc.invalidateQueries({ queryKey: [k] })))
    },
  })
  const confirmToggle = () => {
    const msg = isRemoved
      ? 'Restore this person? Their links to other people will be re-enabled.'
      : 'Disable this person? They will be hidden and all their relationship links switched off. Nothing is deleted.'
    if (window.confirm(msg)) toggle.mutate()
  }
  return (
    <>
      <QueryState loading={isLoading} error={error ?? toggle.error} />
      {data && (
        <Box bg="white" p={6} rounded="lg" shadow="sm">
          {editing ? (
            <PersonEditForm person={data} onDone={() => setEditing(false)} />
          ) : (
            <>
              <HStack justify="space-between" align="start">
                <Heading color="brand.800">{fullName(data)} {isRemoved && <Badge colorScheme="red">Disabled</Badge>}</Heading>
                {user?.role === 'admin' && (
                  <HStack>
                    <Button size="sm" colorScheme="orange" onClick={() => setEditing(true)}>Edit</Button>
                    <Button size="sm" variant="outline" colorScheme={isRemoved ? 'green' : 'red'} isLoading={toggle.isPending} onClick={confirmToggle}>
                      {isRemoved ? 'Restore' : 'Disable'}
                    </Button>
                  </HStack>
                )}
              </HStack>
              {data.clan_name && <Text>Clan name: {data.clan_name}</Text>}
              <Text>Born: {fmtDate(data.birth_date) || 'unknown'}{data.birth_place ? `, ${data.birth_place}` : ''}</Text>
              {!Number(data.is_living) && <Text>Died: {fmtDate(data.death_date) || 'unknown'}</Text>}
              {data.bio && <Text mt={4} whiteSpace="pre-wrap">{data.bio}</Text>}
            </>
          )}
          <Link as={RouterLink} to="/family-tree" color="brand.600" display="block" mt={4}>← Back to the family tree</Link>
        </Box>
      )}
    </>
  )
}
