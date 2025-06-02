// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({

  compatibilityDate: '2025-05-15',
  devtools: { enabled: true },
  nitro: {
     devProxy: {
       '/api': {
         target: 'http://localhost:3001/api',
         changeOrigin: true
       }
     }
   }
})