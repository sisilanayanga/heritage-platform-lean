import react from '@vitejs/plugin-react'
import { defineConfig } from 'vite'

// In dev, serve the PHP API with: php -S localhost:8080 -t ../api (see README)
export default defineConfig({
  plugins: [react()],
  server: {
    proxy: { '/api': { target: 'http://localhost:8080', rewrite: (p) => p.replace(/^\/api/, '') } },
  },
})
