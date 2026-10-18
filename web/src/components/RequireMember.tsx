import { Alert, AlertIcon, Center, Spinner } from '@chakra-ui/react'
import type { ReactNode } from 'react'
import { Navigate } from 'react-router-dom'
import { useAuth } from '../auth/AuthContext'

export function RequireMember({ admin = false, perm, anyOf, children }: { admin?: boolean; perm?: string; anyOf?: string[]; children: ReactNode }) {
  const { user, loading, can, canAny } = useAuth()
  if (loading) return <Center py={20}><Spinner /></Center>
  if (!user) return <Navigate to="/login" replace />
  if (admin && user.role !== 'admin') return <Alert status="error"><AlertIcon />Admins only.</Alert>
  if (perm && !can(perm)) return <Alert status="warning"><AlertIcon />You do not have access to this page. Ask an administrator to grant you access.</Alert>
  if (anyOf && !canAny(...anyOf)) return <Alert status="warning"><AlertIcon />You do not have access to this page. Ask an administrator to grant you access.</Alert>
  return <>{children}</>
}
