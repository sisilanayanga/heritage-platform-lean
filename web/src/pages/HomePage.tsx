import { Badge, Box, Heading, HStack, SimpleGrid, Text, Button, Stack } from '@chakra-ui/react'
import { useQuery } from '@tanstack/react-query'
import { Link } from 'react-router-dom'
import { useAuth } from '../auth/AuthContext'
import { QueryState, fmtDate } from '../components/ui'
import { clan } from '../config/clan'
import { api, type Announcement, type Story } from '../lib/api'
import { EvidenceBadge } from './StoryPages'

export function HomePage() {
  const { user, can } = useAuth()
  const { data, isLoading, error } = useQuery({ queryKey: ['announcements', !!user, can('announcements.view_members')], queryFn: () => api<Announcement[]>('announcements') })

  const canRead = can('stories.view')
  const highlights = useQuery({ queryKey: ['story-highlights'], queryFn: () => api<Story[]>('stories/highlights'), enabled: canRead })

  return (
    <Stack spacing={10}>
      <Box bg="brand.700" color="white" rounded="xl" p={{ base: 6, md: 12 }}>
        <Heading size="2xl">Welcome to the {clan.name} clan</Heading>
        <Text mt={4} fontSize="lg" maxW="2xl">{clan.tagline}. This is our shared home to record where we come from, who we are, and who came before us.</Text>
        <Stack direction={{ base: 'column', sm: 'row' }} mt={6} spacing={3}>
          <Button as={Link} to="/history" colorScheme="orange">Read our history</Button>
          {!user && <Button as={Link} to="/register" variant="outline" colorScheme="whiteAlpha">Join the family space</Button>}
          {user && <Button as={Link} to="/family-tree" variant="outline" colorScheme="whiteAlpha">Open the family tree</Button>}
        </Stack>
      </Box>

      <Box>
        <Heading size="lg" mb={4} color="brand.800">Announcements</Heading>
        <QueryState loading={isLoading} error={error} />
        {data?.length === 0 && <Text>No announcements yet.</Text>}
        <SimpleGrid columns={{ base: 1, md: 2 }} spacing={4}>
          {data?.map((a) => (
            <Box key={a.id} bg="white" p={5} rounded="lg" shadow="sm" borderLeft="4px solid" borderColor="brand.500">
              <Heading size="md">{a.title}</Heading>
              <Text fontSize="xs" color="gray.500" mb={2}>{fmtDate(a.published_at)}</Text>
              <Text whiteSpace="pre-wrap">{a.body}</Text>
            </Box>
          ))}
        </SimpleGrid>
      </Box>

      {canRead && highlights.data && highlights.data.length > 0 && (
        <Box>
          <HStack justify="space-between" mb={4}>
            <Heading size="lg" color="brand.800">Most read stories</Heading>
            <Button as={Link} to="/stories" size="sm" variant="outline" colorScheme="orange">All stories</Button>
          </HStack>
          <SimpleGrid columns={{ base: 1, md: 3 }} spacing={4}>
            {highlights.data.map((s) => (
              <Box key={s.id} as={Link} to={`/stories/${s.id}`} bg="white" p={5} rounded="lg" shadow="sm" _hover={{ shadow: 'md' }}>
                <HStack spacing={2} mb={1} wrap="wrap">
                  {s.date_label && <Badge colorScheme="blue">{s.date_label}</Badge>}
                  <EvidenceBadge status={s.evidence_status} />
                </HStack>
                <Heading size="sm" color="brand.700">{s.title}</Heading>
                {s.summary && <Text mt={2} fontSize="sm">{s.summary}</Text>}
                <Text mt={2} fontSize="xs" color="gray.500">{Number(s.view_count)} reads</Text>
              </Box>
            ))}
          </SimpleGrid>
        </Box>
      )}

      <SimpleGrid columns={{ base: 1, md: 3 }} spacing={4}>
        {[
          ['Lineage', 'Trace the Sokhulu line from our earliest known ancestors.', '/history'],
          ['Iziduko', 'The praise names that carry our identity.', '/iziduko'],
          ['Culture', 'Ceremonies and customs we keep alive.', '/culture'],
        ].map(([t, d, to]) => (
          <Box key={to} as={Link} to={to} bg="white" p={5} rounded="lg" shadow="sm" _hover={{ shadow: 'md' }}>
            <Heading size="md" color="brand.700">{t}</Heading>
            <Text mt={2}>{d}</Text>
          </Box>
        ))}
      </SimpleGrid>
    </Stack>
  )
}
