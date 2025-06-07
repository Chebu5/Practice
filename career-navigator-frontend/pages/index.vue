<template>
  <div class="employer-dashboard">
    <h1>Личный кабинет работодателя</h1>

    <nav class="menu">
      <button @click="currentView = 'profile'">Профиль</button>
      <button @click="currentView = 'vacancies'">Вакансии</button>
      <button @click="currentView = 'graduates'">Профили выпускников</button>
      <button @click="currentView = 'messages'">Сообщения вузам</button>
      <button @click="handleLogout" class="logout-button">Выйти</button>
    </nav>

    <component :is="currentComponent" />

  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'

// Импортируем компоненты (создадим их ниже)
import EmployerProfile from './EmployerProfile.vue'
import EmployerVacancies from './EmployerVacancies.vue'
import GraduateList from './GraduateList.vue'
import EmployerMessages from './EmployerMessages.vue'

const router = useRouter()
const currentView = ref('profile')

const componentsMap = {
  profile: EmployerProfile,
  vacancies: EmployerVacancies,
  graduates: GraduateList,
  messages: EmployerMessages,
}

const currentComponent = computed(() => componentsMap[currentView.value])

const handleLogout = () => {
  localStorage.removeItem('auth_token')
  localStorage.removeItem('role')
  router.push('/login')
}
</script>

<style scoped>
.employer-dashboard {
  max-width: 900px;
  margin: 0 auto;
  padding: 20px;
}
.menu {
  display: flex;
  gap: 10px;
  margin-bottom: 20px;
}
.menu button {
  padding: 10px 15px;
  cursor: pointer;
  border: none;
  background-color: #3498db;
  color: white;
  border-radius: 4px;
  font-weight: 600;
  transition: background-color 0.3s ease;
}
.menu button:hover {
  background-color: #2980b9;
}
.logout-button {
  margin-left: auto;
  background-color: #e74c3c;
}
.logout-button:hover {
  background-color: #c0392b;
}
</style>
