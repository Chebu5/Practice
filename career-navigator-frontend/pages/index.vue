<template>
  <div class="vacancies-container">
    <h1>Список вакансий</h1>
    
    <div class="vacancy-card" v-for="vacancy in vacancies" :key="vacancy.vacancy_id">
      <h2>{{ vacancy.title }}</h2>
      <p class="company-name">{{ vacancy.employer?.company_name }}</p>
      <p class="salary" v-if="vacancy.min_salary || vacancy.max_salary">
        Зарплата: {{ vacancy.min_salary ? `${vacancy.min_salary} - ` : '' }}{{ vacancy.max_salary || '' }} руб.
      </p>
      <div class="description">
        <h3>Описание:</h3>
        <p>{{ vacancy.description }}</p>
      </div>
      <div class="contacts" v-if="vacancy.employer?.contact_phone">
        <h3>Контакты:</h3>
        <p>{{ vacancy.employer.contact_phone }}</p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'

const vacancies = ref([])

const fetchVacancies = async () => {
  try {
    const response = await fetch('/api/vacancies')
    if (!response.ok) throw new Error('Ошибка загрузки вакансий')
    vacancies.value = await response.json()
  } catch (error) {
    console.error('Ошибка при загрузке вакансий:', error)
  }
}

onMounted(fetchVacancies)
</script>

<style scoped>
.vacancies-container {
  max-width: 800px;
  margin: 0 auto;
  padding: 20px;
}

.vacancy-card {
  background: #f9f9f9;
  border-radius: 8px;
  padding: 20px;
  margin-bottom: 20px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}

.company-name {
  color: #555;
  font-style: italic;
  margin-top: -10px;
}

.salary {
  color: #2c3e50;
  font-weight: bold;
}

.description, .contacts {
  margin-top: 15px;
}

h3 {
  margin-bottom: 5px;
  color: #333;
}
</style>