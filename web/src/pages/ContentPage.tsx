import { Box, Text } from '@chakra-ui/react'
import { useQuery } from '@tanstack/react-query'
import { PageTitle, QueryState } from '../components/ui'
import { api } from '../lib/api'

interface Page { slug: string; title: string; body: string }

// Text-driven public pages: content lives in the content_pages table and is editable by admins.
export function ContentPage({ slug, title, sub }: { slug: string; title: string; sub?: string }) {
  const { data, isLoading, error } = useQuery({ queryKey: ['page', slug], queryFn: () => api<Page>(`pages/${slug}`) })
  return (
    <>
      <PageTitle sub={sub}>{data?.title ?? title}</PageTitle>
      <QueryState loading={isLoading} error={error} />
      {data && <Box bg="white" p={{ base: 5, md: 8 }} rounded="lg" shadow="sm"><Text whiteSpace="pre-wrap" lineHeight="tall">{data.body}</Text></Box>}
    </>
  )
}
