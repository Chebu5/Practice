// middleware/auth.global.ts
import { defineNuxtRouteMiddleware, navigateTo } from '#imports'

const publicPages = ['/login', '/register']

export default defineNuxtRouteMiddleware((to) => {
  // Проверяем, что код выполняется на клиенте
  if (!process.client) return

  // Получаем токен из localStorage
  const token = localStorage.getItem('auth_token')

  // Если нет токена и маршрут не в списке публичных — редирект на /login
  if (!token && !publicPages.includes(to.path)) {
    return navigateTo('/login')
  }
})
