import { Alert, AlertIcon, Center, Spinner } from '@chakra-ui/react'
import type { ReactNode } from 'react'
import { Navigate } from 'react-router-dom'
import { useAuth } from '../auth/AuthContext'

export function RequireMember({ admin = false, children }: { admin?: boolean; children: ReactNode }) {
  const { user, loading } = useAuth()
  if (loading) return <Center py={20}><Spinner /></Center>
  if (!user) return <Navigate to="/login" replace />
  if (admin && user.role !== 'admin') return <Alert status="error"><AlertIcon />Admins only.</Alert>
  return <>{children}</>
}
