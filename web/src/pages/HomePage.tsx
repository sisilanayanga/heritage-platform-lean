import { Box, Heading, SimpleGrid, Text, Button, Stack } from '@chakra-ui/react'
import { useQuery } from '@tanstack/react-query'
import { Link } from 'react-router-dom'
import { useAuth } from '../auth/AuthContext'
import { QueryState, fmtDate } from '../components/ui'
import { clan } from '../config/clan'
import { api, type Announcement } from '../lib/api'

export function HomePage() {
  const { user, can } = useAuth()
  const { data, isLoading, error } = useQuery({ queryKey: ['announcements', !!user, can('announcements.view_members')], queryFn: () => api<Announcement[]>('announcements') })

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
