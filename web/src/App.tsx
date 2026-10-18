import type { ReactNode } from 'react'
import { Navigate, Route, Routes } from 'react-router-dom'
import { Layout } from './components/Layout'
import { RequireMember } from './components/RequireMember'
import { AdminPage } from './pages/AdminPage'
import { LoginPage, RegisterPage } from './pages/AuthPages'
import { ContactPage } from './pages/ContactPage'
import { ContentPage } from './pages/ContentPage'
import { FamilyTreePage } from './pages/FamilyTreePage'
import { HomePage } from './pages/HomePage'
import { ComingSoon, EventsPage, PlacesPage } from './pages/MemberPages'
import { StoriesPage, StoryPage } from './pages/StoryPages'
import { PeoplePage, PersonPage } from './pages/PeoplePages'
import { ADMIN_AREA_PERMS } from './lib/permissions'

const member = (el: ReactNode, perm?: string) => <RequireMember perm={perm}>{el}</RequireMember>

export default function App() {
  return (
    <Routes>
      <Route element={<Layout />}>
        <Route index element={<HomePage />} />
        <Route path="history" element={<ContentPage slug="history" title="Our History" sub="Origins and lineage of the clan" />} />
        <Route path="iziduko" element={<ContentPage slug="iziduko" title="Iziduko" sub="Clan praise names" />} />
        <Route path="culture" element={<ContentPage slug="culture" title="Culture & Customs" sub="Ceremonies and traditions" />} />
        <Route path="contact" element={<ContactPage />} />
        <Route path="login" element={<LoginPage />} />
        <Route path="register" element={<RegisterPage />} />

        <Route path="family-tree" element={member(<FamilyTreePage />, 'tree.view')} />
        <Route path="people" element={member(<PeoplePage />, 'people.view')} />
        <Route path="people/:id" element={member(<PersonPage />, 'people.view')} />
        <Route path="stories" element={member(<StoriesPage />, 'stories.view')} />
        <Route path="stories/:id" element={member(<StoryPage />, 'stories.view')} />
        <Route path="events" element={member(<EventsPage />, 'events.view')} />
        <Route path="places" element={member(<PlacesPage />, 'places.view')} />
        <Route path="gallery" element={member(<ComingSoon title="Gallery" sub="Family photographs" />, 'gallery.view')} />
        <Route path="documents" element={member(<ComingSoon title="Documents" sub="Certificates, letters and records" />, 'documents.view')} />
        <Route path="admin" element={<RequireMember anyOf={ADMIN_AREA_PERMS}><AdminPage /></RequireMember>} />
        <Route path="*" element={<Navigate to="/" replace />} />
      </Route>
    </Routes>
  )
}
