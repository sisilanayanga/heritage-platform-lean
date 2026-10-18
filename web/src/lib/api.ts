export class ApiError extends Error {
  status: number
  constructor(status: number, message: string) {
    super(message)
    this.status = status
  }
}

let csrfToken = ''
export const setCsrfToken = (t: string) => {
  csrfToken = t
}

export async function api<T>(path: string, init: { method?: string; body?: unknown } = {}): Promise<T> {
  const method = init.method ?? 'GET'
  const res = await fetch(`/api/${path}`, {
    method,
    credentials: 'same-origin',
    headers: {
      ...(init.body !== undefined ? { 'Content-Type': 'application/json' } : {}),
      ...(method !== 'GET' ? { 'X-CSRF-Token': csrfToken } : {}),
    },
    body: init.body !== undefined ? JSON.stringify(init.body) : undefined,
  })
  const data = await res.json().catch(() => ({}))
  if (!res.ok) throw new ApiError(res.status, (data as { error?: string }).error ?? 'Request failed')
  return data as T
}

export interface Person {
  id: number
  given_name: string
  family_name: string | null
  clan_name: string | null
  gender?: string | null
  birth_date: string | null
  death_date: string | null
  is_living: number | string
  birth_place?: string | null
  bio?: string | null
  removed?: number | string
}
export interface Relationship {
  person_id: number
  related_person_id: number
  type: 'parent_of' | 'spouse_of'
}
export interface Announcement { id: number; title: string; body: string; published_at: string }
export interface Story { id: number; title: string; body: string; narrator: string | null }
export interface ClanEvent { id: number; title: string; kind: string | null; event_date: string | null; location: string | null; details: string | null }
export interface Place { id: number; name: string; kind: string; description: string | null }
export interface PendingUser { id: number; email: string; full_name: string; relationship_note: string | null; role: string; status: string; created_at: string }
