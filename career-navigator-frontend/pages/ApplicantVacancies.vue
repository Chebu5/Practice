<template>
  <div class="applicant-vacancies">
    <h2>Доступные вакансии</h2>
    <div v-if="loading">Загрузка...</div>
    <ul v-else>
      <li v-for="vacancy in vacancies" :key="vacancy.vacancy_id" class="vacancy-item">
        <h3>{{ vacancy.title }}</h3>
        <p>{{ vacancy.description }}</p>
        <p>Зарплата: {{ vacancy.min_salary }} - {{ vacancy.max_salary }}</p>
      </li>
    </ul>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'

const vacancies = ref([])
const loading = ref(false)
const token = localStorage.getItem('auth_token')

const fetchVacancies = async () => {
  loading.value = true
  try {
    const res = await fetch('/api/applicant/vacancies', {
      headers: { Authorization: `Bearer ${token}` }
    })
    if (res.ok) {
      vacancies.value = await res.json()
    }
  } catch (e) {
    console.error('Ошибка загрузки вакансий', e)
  } finally {
    loading.value = false
  }
}

onMounted(fetchVacancies)
</script>

<style scoped>
.applicant-vacancies {
  max-width: 700px;
  margin: 20px auto;
  font-family: Arial, sans-serif;
}
.vacancy-item {
  background: #f9f9f9;
  padding: 15px;
  margin-bottom: 15px;
  border-radius: 8px;
}
.vacancy-item h3 {
  margin: 0 0 10px 0;
}
</style>
