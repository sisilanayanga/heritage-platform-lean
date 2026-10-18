import { Box, Button, Container, Flex, HStack, IconButton, Link, Stack, Text, useDisclosure } from '@chakra-ui/react'
import { Link as RouterLink, NavLink, Outlet, useNavigate } from 'react-router-dom'
import { useAuth } from '../auth/AuthContext'
import { clan } from '../config/clan'

const publicLinks = [
  ['/', 'Home'],
  ['/history', 'History'],
  ['/izithakazelo', 'Izithakazelo'],
  ['/culture', 'Culture'],
  ['/contact', 'Contact'],
] as const

const memberLinks = [
  ['/family-tree', 'Family Tree'],
  ['/people', 'People'],
  ['/stories', 'Stories'],
  ['/events', 'Events'],
  ['/places', 'Places'],
  ['/gallery', 'Gallery'],
  ['/documents', 'Documents'],
] as const

export function Layout() {
  const { user, logout } = useAuth()
  const navigate = useNavigate()
  const { isOpen, onToggle, onClose } = useDisclosure()

  const links = [...publicLinks, ...(user ? memberLinks : []), ...(user?.role === 'admin' ? ([['/admin', 'Admin']] as const) : [])]

  return (
    <Flex direction="column" minH="100vh">
      <Box bg="brand.800" color="white" position="sticky" top={0} zIndex={10}>
        <Container maxW="6xl" py={3}>
          <Flex align="center" justify="space-between" wrap="wrap" gap={2}>
            <Link as={RouterLink} to="/" fontFamily="heading" fontSize="xl" fontWeight="bold" _hover={{ textDecoration: 'none' }}>
              {clan.name} Heritage
            </Link>
            <IconButton display={{ base: 'inline-flex', lg: 'none' }} aria-label="Toggle menu" onClick={onToggle} variant="outline" colorScheme="whiteAlpha" icon={<Text>{isOpen ? '✕' : '☰'}</Text>} />
            <Stack
              display={{ base: isOpen ? 'flex' : 'none', lg: 'flex' }}
              direction={{ base: 'column', lg: 'row' }}
              w={{ base: 'full', lg: 'auto' }}
              spacing={{ base: 2, lg: 4 }}
              align={{ base: 'start', lg: 'center' }}
            >
              {links.map(([to, label]) => (
                <NavLink key={to} to={to} onClick={onClose} style={({ isActive }) => ({ fontWeight: isActive ? 700 : 400, textDecoration: isActive ? 'underline' : 'none' })}>
                  {label}
                </NavLink>
              ))}
              {user ? (
                <Button size="sm" onClick={() => void logout().then(() => navigate('/'))}>Log out</Button>
              ) : (
                <HStack>
                  <Button as={RouterLink} to="/login" size="sm" colorScheme="brand">Log in</Button>
                  <Button as={RouterLink} to="/register" size="sm" variant="outline" colorScheme="whiteAlpha">Register</Button>
                </HStack>
              )}
            </Stack>
          </Flex>
        </Container>
      </Box>
      <Box flex="1" bg="orange.50">
        <Container maxW="6xl" py={8}>
          <Outlet />
        </Container>
      </Box>
      <Box bg="brand.900" color="whiteAlpha.800" py={4} textAlign="center" fontSize="sm">
        © {new Date().getFullYear()} {clan.name} clan · Preserving our heritage
      </Box>
    </Flex>
  )
}
