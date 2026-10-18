import { createContext, useContext, useEffect, useState, type ReactNode } from 'react'
import { api, setCsrfToken } from '../lib/api'

export interface User { id: number; email: string; fullName: string; role: 'member' | 'admin' }

interface AuthState {
  user: User | null
  loading: boolean
  login: (email: string, password: string) => Promise<void>
  logout: () => Promise<void>
}

const Ctx = createContext<AuthState | null>(null)

export function AuthProvider({ children }: { children: ReactNode }) {
  const [user, setUser] = useState<User | null>(null)
  const [loading, setLoading] = useState(true)

  const refresh = async () => {
    try {
      const r = await api<{ user: User | null; csrfToken?: string }>('auth/me')
      setUser(r.user)
      setCsrfToken(r.csrfToken ?? '')
    } catch {
      setUser(null)
    } finally {
      setLoading(false)
    }
  }

  useEffect(() => {
    void refresh()
  }, [])

  const login = async (email: string, password: string) => {
    await api('auth/login', { method: 'POST', body: { email, password } })
    await refresh()
  }
  const logout = async () => {
    await api('auth/logout', { method: 'POST' })
    setUser(null)
    setCsrfToken('')
  }

  return <Ctx.Provider value={{ user, loading, login, logout }}>{children}</Ctx.Provider>
}

export function useAuth() {
  const v = useContext(Ctx)
  if (!v) throw new Error('useAuth outside AuthProvider')
  return v
}
