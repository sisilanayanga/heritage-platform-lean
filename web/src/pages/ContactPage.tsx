import { Box, Link, Text } from '@chakra-ui/react'
import { PageTitle } from '../components/ui'
import { clan } from '../config/clan'

export function ContactPage() {
  return (
    <>
      <PageTitle sub="Reach the family administrators">Contact</PageTitle>
      <Box bg="white" p={6} rounded="lg" shadow="sm">
        <Text>Questions, corrections or stories to share? Email <Link color="brand.600" href={`mailto:${clan.contactEmail}`}>{clan.contactEmail}</Link>.</Text>
      </Box>
    </>
  )
}
