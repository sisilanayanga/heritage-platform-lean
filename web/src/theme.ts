import { extendTheme } from '@chakra-ui/react'

export const theme = extendTheme({
  colors: {
    brand: {
      50: '#fdf3e7', 100: '#f9dcb8', 200: '#f2c086', 300: '#e9a255', 400: '#df8a30',
      500: '#c9701a', 600: '#a15714', 700: '#79410f', 800: '#522b09', 900: '#2b1604',
    },
  },
  fonts: { heading: 'Georgia, serif', body: 'system-ui, sans-serif' },
  config: { initialColorMode: 'light', useSystemColorMode: false },
})
