import { Alert, AlertIcon, Heading, Spinner, Text, VStack } from '@chakra-ui/react'
import type { ReactNode } from 'react'

export function PageTitle({ children, sub }: { children: ReactNode; sub?: string }) {
  return (
    <VStack align="start" spacing={1} mb={6}>
      <Heading color="brand.800">{children}</Heading>
      {sub && <Text color="gray.600">{sub}</Text>}
    </VStack>
  )
}

export function QueryState({ loading, error }: { loading: boolean; error: unknown }) {
  if (loading) return <Spinner />
  if (error) return <Alert status="error"><AlertIcon />{error instanceof Error ? error.message : 'Something went wrong'}</Alert>
  return null
}

export function Notice({ children }: { children: ReactNode }) {
  return <Alert status="info" rounded="md"><AlertIcon />{children}</Alert>
}

export const fmtDate = (d: string | null) => (d ? d.slice(0, 10) : '')
export const fullName = (p: { given_name: string; family_name: string | null }) => [p.given_name, p.family_name].filter(Boolean).join(' ')
