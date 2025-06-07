<template>
  <form @submit.prevent="submitVacancy">
    <input v-model="title" placeholder="Название вакансии" required />
    <textarea v-model="description" placeholder="Описание"></textarea>
    <input v-model.number="min_salary" type="number" placeholder="Мин. зарплата" />
    <input v-model.number="max_salary" type="number" placeholder="Макс. зарплата" />

    <h3>Требования к образованию</h3>
    <div v-for="(req, index) in educationRequirements" :key="index">
      <input v-model.number="req.specialization_id" placeholder="ID специальности" required />
      <select v-model="req.degree_level" required>
        <option>Бакалавр</option>
        <option>Магистр</option>
        <option>Специалитет</option>
      </select>
      <button @click.prevent="removeEducationRequirement(index)">Удалить</button>
    </div>
    <button @click.prevent="addEducationRequirement">Добавить требование</button>

    <h3>Навыки (ID через запятую)</h3>
    <input v-model="skillIdsInput" placeholder="1,2,3" />

    <button type="submit">Создать вакансию</button>
  </form>
</template>

<script setup>
import { ref } from 'vue'

const title = ref('')
const description = ref('')
const min_salary = ref(null)
const max_salary = ref(null)
const educationRequirements = ref([{ specialization_id: null, degree_level: 'Бакалавр' }])
const skillIdsInput = ref('')

const addEducationRequirement = () => {
  educationRequirements.value.push({ specialization_id: null, degree_level: 'Бакалавр' })
}
const removeEducationRequirement = (index) => {
  educationRequirements.value.splice(index, 1)
}

const submitVacancy = async () => {
  const skillIds = skillIdsInput.value.split(',').map(id => Number(id.trim())).filter(id => !isNaN(id))

  const payload = {
    title: title.value,
    description: description.value,
    min_salary: min_salary.value,
    max_salary: max_salary.value,
    educationRequirements: educationRequirements.value,
    skillIds,
  }

  const token = localStorage.getItem('auth_token')

  const response = await fetch('/api/employer/vacancies', {
    method: 'POST',
    headers: { 
      'Content-Type': 'application/json',
      'Authorization': `Bearer ${token}`
    },
    body: JSON.stringify(payload)
  })

  if (response.ok) {
    alert('Вакансия создана')
    // Очистить форму или обновить список вакансий
  } else {
    const data = await response.json()
    alert('Ошибка: ' + data.error)
  }
}
</script>
