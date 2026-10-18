import { Alert, AlertIcon, Box, Button, FormControl, FormLabel, Input, Link, Stack, Text, Textarea } from '@chakra-ui/react'
import { useState, type FormEvent } from 'react'
import { Link as RouterLink, useNavigate } from 'react-router-dom'
import { useAuth } from '../auth/AuthContext'
import { PageTitle } from '../components/ui'
import { api } from '../lib/api'

export function LoginPage() {
  const { login } = useAuth()
  const navigate = useNavigate()
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [error, setError] = useState('')
  const [busy, setBusy] = useState(false)

  const submit = async (e: FormEvent) => {
    e.preventDefault()
    setBusy(true)
    setError('')
    try {
      await login(email, password)
      navigate('/family-tree')
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Login failed')
    } finally {
      setBusy(false)
    }
  }

  return (
    <Box maxW="md" mx="auto">
      <PageTitle>Log in</PageTitle>
      <Stack as="form" onSubmit={submit} spacing={4} bg="white" p={6} rounded="lg" shadow="sm">
        {error && <Alert status="error"><AlertIcon />{error}</Alert>}
        <FormControl isRequired><FormLabel>Email</FormLabel><Input type="email" value={email} onChange={(e) => setEmail(e.target.value)} autoComplete="username" /></FormControl>
        <FormControl isRequired><FormLabel>Password</FormLabel><Input type="password" value={password} onChange={(e) => setPassword(e.target.value)} autoComplete="current-password" /></FormControl>
        <Button type="submit" colorScheme="orange" isLoading={busy}>Log in</Button>
        <Text fontSize="sm">No account? <Link as={RouterLink} to="/register" color="brand.600">Register</Link> — an administrator must approve it.</Text>
      </Stack>
    </Box>
  )
}

export function RegisterPage() {
  const [form, setForm] = useState({ fullName: '', email: '', password: '', relationshipNote: '' })
  const [error, setError] = useState('')
  const [done, setDone] = useState(false)
  const [busy, setBusy] = useState(false)
  const set = (k: keyof typeof form) => (e: { target: { value: string } }) => setForm({ ...form, [k]: e.target.value })

  const submit = async (e: FormEvent) => {
    e.preventDefault()
    setBusy(true)
    setError('')
    try {
      await api('auth/register', { method: 'POST', body: form })
      setDone(true)
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Registration failed')
    } finally {
      setBusy(false)
    }
  }

  if (done) {
    return (
      <Box maxW="md" mx="auto">
        <Alert status="success" rounded="md"><AlertIcon />Thank you! Your registration was received. You will be emailed once an administrator approves it.</Alert>
      </Box>
    )
  }

  return (
    <Box maxW="md" mx="auto">
      <PageTitle sub="Access to the family tree and people is for approved family members only.">Register</PageTitle>
      <Stack as="form" onSubmit={submit} spacing={4} bg="white" p={6} rounded="lg" shadow="sm">
        {error && <Alert status="error"><AlertIcon />{error}</Alert>}
        <FormControl isRequired><FormLabel>Full name</FormLabel><Input value={form.fullName} onChange={set('fullName')} maxLength={160} /></FormControl>
        <FormControl isRequired><FormLabel>Email</FormLabel><Input type="email" value={form.email} onChange={set('email')} autoComplete="username" /></FormControl>
        <FormControl isRequired><FormLabel>Password (min 10 characters)</FormLabel><Input type="password" minLength={10} value={form.password} onChange={set('password')} autoComplete="new-password" /></FormControl>
        <FormControl><FormLabel>How are you related to the Sokhulu family?</FormLabel><Textarea value={form.relationshipNote} onChange={set('relationshipNote')} maxLength={500} placeholder="e.g. Grandson of ..., from ... homestead" /></FormControl>
        <Button type="submit" colorScheme="orange" isLoading={busy}>Submit for approval</Button>
      </Stack>
    </Box>
  )
}
