import { Badge, Box, Heading, Link, Text, VStack } from '@chakra-ui/react'
import { useQuery } from '@tanstack/react-query'
import { Notice, PageTitle, QueryState, fmtDate } from '../components/ui'
import { api, type ClanEvent, type Place } from '../lib/api'
import { EvidenceBadge } from './StoryPages'

export function EventsPage() {
  const { data, isLoading, error } = useQuery({ queryKey: ['events'], queryFn: () => api<ClanEvent[]>('events') })
  return (
    <>
      <PageTitle sub="Gatherings, ceremonies, reunions and milestones">Events</PageTitle>
      <QueryState loading={isLoading} error={error} />
      {data?.length === 0 && <Text>No events yet.</Text>}
      <VStack align="stretch" spacing={4}>
        {data?.map((e) => (
          <Box key={e.id} bg="white" p={5} rounded="lg" shadow="sm">
            <Heading size="md">{e.title} {e.kind && <Badge ml={2} colorScheme="orange">{e.kind}</Badge>}</Heading>
            <Text fontSize="sm" color="gray.600">{fmtDate(e.event_date)} {e.location && `· ${e.location}`}</Text>
            {e.details && <Text mt={2} whiteSpace="pre-wrap">{e.details}</Text>}
          </Box>
        ))}
      </VStack>
    </>
  )
}

function PlaceMap({ place }: { place: Place }) {
  const lat = Number(place.latitude)
  const lon = Number(place.longitude)
  if (place.latitude === null || place.longitude === null || Number.isNaN(lat) || Number.isNaN(lon)) {
    return <Text mt={3} fontSize="sm" color="orange.700">Map location to be confirmed.</Text>
  }
  const d = 0.04
  const src = `https://www.openstreetmap.org/export/embed.html?bbox=${lon - d},${lat - d},${lon + d},${lat + d}&layer=mapnik&marker=${lat},${lon}`
  return (
    <Box mt={3}>
      <Box as="iframe" title={`Map of ${place.name}`} src={src} w="full" h="280px" border="1px solid" borderColor="gray.200" rounded="md" loading="lazy" />
      <Link href={`https://www.openstreetmap.org/?mlat=${lat}&mlon=${lon}#map=13/${lat}/${lon}`} isExternal fontSize="sm" color="brand.600">Open larger map</Link>
    </Box>
  )
}

export function PlacesPage() {
  const { data, isLoading, error } = useQuery({ queryKey: ['places'], queryFn: () => api<Place[]>('places') })
  return (
    <>
      <PageTitle sub="Ancestral homesteads, graves and places of origin">Places</PageTitle>
      <QueryState loading={isLoading} error={error} />
      {data?.length === 0 && <Text>No places recorded yet.</Text>}
      <VStack align="stretch" spacing={4}>
        {data?.map((p) => (
          <Box key={p.id} bg="white" p={5} rounded="lg" shadow="sm">
            <Heading size="md">{p.name} <Badge ml={2}>{p.kind}</Badge> <EvidenceBadge status={p.evidence_status} /></Heading>
            {p.description && <Text mt={2} whiteSpace="pre-wrap">{p.description}</Text>}
            <PlaceMap place={p} />
          </Box>
        ))}
      </VStack>
    </>
  )
}

export function ComingSoon({ title, sub }: { title: string; sub: string }) {
  return (
    <>
      <PageTitle sub={sub}>{title}</PageTitle>
      <Notice>Coming soon. File uploads are intentionally left out of the lean version; see docs/DESIGN_DECISIONS.md.</Notice>
    </>
  )
}
