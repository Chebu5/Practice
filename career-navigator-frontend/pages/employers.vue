<template>
  <div>
    <h1>Личный кабинет работодателя</h1>
    <p>Добро пожаловать на страницу работодателя!</p>

    <h2>Список вакансий</h2>
    <ul>
      <li v-for="vacancy in vacancies" :key="vacancy.id">
        <strong>{{ vacancy.title }}</strong>: {{ vacancy.description }}
      </li>
    </ul>
  </div>
</template>

<script setup>
import { ref } from 'vue'

// Статический список вакансий
const vacancies = ref([
  { id: 1, title: 'Frontend-разработчик', description: 'Разработка интерфейсов на Vue.js' },
  { id: 2, title: 'Backend-разработчик', description: 'Создание API на Node.js' },
  { id: 3, title: 'Дизайнер', description: 'Создание макетов и прототипов' }
])
</script>
