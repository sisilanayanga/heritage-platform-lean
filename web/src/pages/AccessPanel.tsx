import {
  Alert, AlertIcon, Badge, Box, Button, Checkbox, FormControl, FormLabel, HStack, Input, Modal, ModalBody, ModalCloseButton, ModalContent, ModalFooter, ModalHeader, ModalOverlay,
  SimpleGrid, Stack, Tab, TabList, TabPanel, TabPanels, Tabs, Text, useDisclosure,
} from '@chakra-ui/react'
import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query'
import { useState } from 'react'
import { useAuth } from '../auth/AuthContext'
import { QueryState } from '../components/ui'
import { api } from '../lib/api'

interface Perm { code: string; label: string; grp: string }
interface Role { id: number; name: string; description: string | null; is_system: number; is_default: number; is_admin: number; permissions: string[] }
interface AccessUser { id: number; full_name: string; email: string; role: string; roleIds: number[]; permissions: string[] }
interface Rbac { permissions: Perm[]; roles: Role[]; users: AccessUser[] }

const useRbac = () => useQuery({ queryKey: ['rbac'], queryFn: () => api<Rbac>('admin/rbac') })

function PermissionChecklist({ perms, value, onChange, disabled }: { perms: Perm[]; value: string[]; onChange: (v: string[]) => void; disabled?: boolean }) {
  const groups = [...new Set(perms.map((p) => p.grp))]
  const toggle = (code: string) => onChange(value.includes(code) ? value.filter((c) => c !== code) : [...value, code])
  return (
    <SimpleGrid columns={{ base: 1, md: 2 }} spacing={4}>
      {groups.map((g) => (
        <Box key={g}>
          <Text fontWeight="bold" fontSize="sm" mb={1}>{g}</Text>
          <Stack spacing={1}>
            {perms.filter((p) => p.grp === g).map((p) => (
              <Checkbox key={p.code} size="sm" isDisabled={disabled} isChecked={value.includes(p.code)} onChange={() => toggle(p.code)}>{p.label}</Checkbox>
            ))}
          </Stack>
        </Box>
      ))}
    </SimpleGrid>
  )
}

function RoleEditor({ rbac, role, onDone }: { rbac: Rbac; role: Role | null; onDone: () => void }) {
  const qc = useQueryClient()
  const [name, setName] = useState(role?.name ?? '')
  const [description, setDescription] = useState(role?.description ?? '')
  const [perms, setPerms] = useState<string[]>(role?.permissions ?? [])
  const save = useMutation({
    mutationFn: () => api(role ? `admin/roles/${role.id}` : 'admin/roles', { method: role ? 'PUT' : 'POST', body: { name, description, permissions: perms } }),
    onSuccess: () => { void qc.invalidateQueries({ queryKey: ['rbac'] }); void qc.invalidateQueries({ queryKey: ['me'] }); onDone() },
  })
  return (
    <Stack spacing={4} bg="white" p={5} rounded="lg" shadow="sm">
      {save.error && <Alert status="error"><AlertIcon />{save.error.message}</Alert>}
      <FormControl isRequired><FormLabel>Role name</FormLabel><Input value={name} onChange={(e) => setName(e.target.value)} isDisabled={!!role?.is_system} /></FormControl>
      <FormControl><FormLabel>Description</FormLabel><Input value={description} onChange={(e) => setDescription(e.target.value)} /></FormControl>
      <PermissionChecklist perms={rbac.permissions} value={perms} onChange={setPerms} />
      <HStack>
        <Button colorScheme="orange" onClick={() => save.mutate()} isLoading={save.isPending} isDisabled={!name.trim()}>Save role</Button>
        <Button variant="ghost" onClick={onDone}>Cancel</Button>
      </HStack>
    </Stack>
  )
}

function Roles({ rbac }: { rbac: Rbac }) {
  const qc = useQueryClient()
  const [editing, setEditing] = useState<Role | 'new' | null>(null)
  const del = useMutation({
    mutationFn: (id: number) => api(`admin/roles/${id}`, { method: 'DELETE' }),
    onSuccess: () => void qc.invalidateQueries({ queryKey: ['rbac'] }),
  })
  if (editing) return <RoleEditor rbac={rbac} role={editing === 'new' ? null : editing} onDone={() => setEditing(null)} />
  return (
    <Stack spacing={3}>
      {del.error && <Alert status="error"><AlertIcon />{del.error.message}</Alert>}
      <Button alignSelf="start" colorScheme="orange" size="sm" onClick={() => setEditing('new')}>New role</Button>
      {rbac.roles.map((r) => (
        <Box key={r.id} bg="white" p={4} rounded="lg" shadow="sm">
          <HStack justify="space-between" align="start" wrap="wrap">
            <Box>
              <HStack>
                <Text fontWeight="bold">{r.name}</Text>
                {r.is_admin ? <Badge colorScheme="red">all permissions</Badge> : null}
                {r.is_default ? <Badge colorScheme="green">default for new members</Badge> : null}
                {r.is_system && !r.is_admin ? <Badge>built-in</Badge> : null}
              </HStack>
              <Text fontSize="sm" color="gray.600">{r.description}</Text>
              {!r.is_admin && <Text fontSize="xs" color="gray.500" mt={1}>{r.permissions.length} permission(s)</Text>}
            </Box>
            {!r.is_admin && (
              <HStack>
                <Button size="xs" onClick={() => setEditing(r)}>Edit</Button>
                {!r.is_system && <Button size="xs" colorScheme="red" variant="outline" onClick={() => window.confirm(`Delete role "${r.name}"?`) && del.mutate(r.id)}>Delete</Button>}
              </HStack>
            )}
          </HStack>
        </Box>
      ))}
    </Stack>
  )
}

function UserAccessModal({ rbac, user, onClose }: { rbac: Rbac; user: AccessUser; onClose: () => void }) {
  const qc = useQueryClient()
  const [roleIds, setRoleIds] = useState<number[]>(user.roleIds)
  const [perms, setPerms] = useState<string[]>(user.permissions)
  const save = useMutation({
    mutationFn: () => api(`admin/users/${user.id}/access`, { method: 'PUT', body: { roleIds, permissions: perms } }),
    onSuccess: () => { void qc.invalidateQueries({ queryKey: ['rbac'] }); onClose() },
  })
  const assignable = rbac.roles.filter((r) => !r.is_admin)
  return (
    <Modal isOpen onClose={onClose} size="2xl" scrollBehavior="inside">
      <ModalOverlay />
      <ModalContent>
        <ModalHeader>Access for {user.full_name}</ModalHeader>
        <ModalCloseButton />
        <ModalBody>
          <Stack spacing={5}>
            {save.error && <Alert status="error"><AlertIcon />{save.error.message}</Alert>}
            <Box>
              <Text fontWeight="bold" mb={1}>Roles</Text>
              <Stack spacing={1}>
                {assignable.map((r) => (
                  <Checkbox key={r.id} isChecked={roleIds.includes(r.id)} onChange={() => setRoleIds(roleIds.includes(r.id) ? roleIds.filter((i) => i !== r.id) : [...roleIds, r.id])}>
                    {r.name} <Text as="span" fontSize="xs" color="gray.500">— {r.description}</Text>
                  </Checkbox>
                ))}
              </Stack>
            </Box>
            <Box>
              <Text fontWeight="bold" mb={1}>Extra permissions (on top of roles)</Text>
              <PermissionChecklist perms={rbac.permissions} value={perms} onChange={setPerms} />
            </Box>
          </Stack>
        </ModalBody>
        <ModalFooter gap={2}>
          <Button variant="ghost" onClick={onClose}>Cancel</Button>
          <Button colorScheme="orange" onClick={() => save.mutate()} isLoading={save.isPending}>Save access</Button>
        </ModalFooter>
      </ModalContent>
    </Modal>
  )
}

function Users({ rbac }: { rbac: Rbac }) {
  const qc = useQueryClient()
  const { user: me } = useAuth()
  const [editing, setEditing] = useState<AccessUser | null>(null)
  const { isOpen, onOpen, onClose } = useDisclosure()
  const toggleAdmin = useMutation({
    mutationFn: ({ id, makeAdmin }: { id: number; makeAdmin: boolean }) => api(`admin/users/${id}/${makeAdmin ? 'make-admin' : 'remove-admin'}`, { method: 'POST' }),
    onSuccess: () => void qc.invalidateQueries({ queryKey: ['rbac'] }),
  })
  const roleName = (id: number) => rbac.roles.find((r) => r.id === id)?.name
  return (
    <Stack spacing={3}>
      {toggleAdmin.error && <Alert status="error"><AlertIcon />{toggleAdmin.error.message}</Alert>}
      {rbac.users.map((u) => {
        const isAdmin = u.role === 'admin'
        return (
          <Box key={u.id} bg="white" p={4} rounded="lg" shadow="sm">
            <HStack justify="space-between" align="start" wrap="wrap" gap={2}>
              <Box>
                <HStack><Text fontWeight="bold">{u.full_name}</Text>{isAdmin && <Badge colorScheme="red">Administrator</Badge>}</HStack>
                <Text fontSize="sm" color="gray.600">{u.email}</Text>
                {!isAdmin && (
                  <HStack mt={1} wrap="wrap">
                    {u.roleIds.map((id) => <Badge key={id} colorScheme="purple">{roleName(id)}</Badge>)}
                    {u.permissions.length > 0 && <Badge colorScheme="blue">+{u.permissions.length} extra</Badge>}
                  </HStack>
                )}
              </Box>
              <HStack>
                {!isAdmin && <Button size="xs" onClick={() => { setEditing(u); onOpen() }}>Manage access</Button>}
                {isAdmin ? (
                  <Button size="xs" colorScheme="red" variant="outline" isDisabled={u.id === me?.id}
                    onClick={() => window.confirm(`Remove admin from ${u.full_name}? All their roles and permissions will be stripped.`) && toggleAdmin.mutate({ id: u.id, makeAdmin: false })}>
                    Remove admin
                  </Button>
                ) : (
                  <Button size="xs" colorScheme="green" onClick={() => window.confirm(`Make ${u.full_name} an administrator with all permissions?`) && toggleAdmin.mutate({ id: u.id, makeAdmin: true })}>
                    Make admin
                  </Button>
                )}
              </HStack>
            </HStack>
          </Box>
        )
      })}
      {isOpen && editing && <UserAccessModal rbac={rbac} user={editing} onClose={onClose} />}
    </Stack>
  )
}

export function AccessPanel() {
  const { data, isLoading, error } = useRbac()
  return (
    <>
      <QueryState loading={isLoading} error={error} />
      {data && (
        <Tabs variant="soft-rounded" colorScheme="orange" size="sm" isLazy>
          <TabList mb={3}><Tab>People</Tab><Tab>Roles</Tab></TabList>
          <TabPanels>
            <TabPanel px={0}><Users rbac={data} /></TabPanel>
            <TabPanel px={0}><Roles rbac={data} /></TabPanel>
          </TabPanels>
        </Tabs>
      )}
    </>
  )
}
