<template>
  <div class="applicant-profile">
    <button @click="logout">Выход</button>
    <h2>Профиль абитуриента</h2>
    <form @submit.prevent="updateProfile">
      <label>ФИО</label>
      <input v-model="applicant.full_name" required />

      <label>Email</label>
      <input v-model="applicant.email" type="email" disabled />

      <label>Телефон</label>
      <input v-model="applicant.phone" />
      
      <button type="submit">Сохранить</button>
    </form>
    <p v-if="message" class="message">{{ message }}</p>

    <hr />

    <h2>Вакансии с требованиями к образованию</h2>
    <div v-if="vacanciesLoading">Загрузка вакансий...</div>
    <div v-else>
      <div v-if="vacancies.length === 0">Вакансии не найдены</div>
      <ul>
        <li v-for="vacancy in vacancies" :key="vacancy.vacancy_id" class="vacancy-item">
  <h3>{{ vacancy.title }}</h3>
  <p><strong>Описание:</strong> {{ vacancy.description }}</p>
  <p><strong>Компания:</strong> {{ vacancy.employer.company_name }}</p>
  <div v-if="vacancy.educationRequirements.length">
    <h4>Требования к образованию:</h4>
    <ul>
      <li v-for="req in vacancy.educationRequirements" :key="req.requirement_id">Уровень: {{ req.degree_level }}</li>
    </ul>
  </div>
  <div v-if="vacancy.skills && vacancy.skills.length">
    <h4>Навыки:</h4>
    <ul>
      <li v-for="skill in vacancy.skills" :key="skill.skill_id">{{ skill.name }}</li>
    </ul>
  </div>
</li>

      </ul>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
const applicant = ref({
  full_name: '',
  email: '',
  phone: ''
})
const message = ref('')
const token = ref('')

const vacancies = ref([])
const vacanciesLoading = ref(false)
const router = useRouter()
onMounted(() => {
  token.value = localStorage.getItem('auth_token')
  fetchProfile()
  fetchVacancies()
})
const logout = () => {
  localStorage.removeItem('auth_token') // удаляем токен
  token.value = '' // сбрасываем реактивную переменную token
  router.push('/login') // перенаправляем на страницу логина
}
const fetchProfile = async () => {
  if (!token.value) {
    message.value = 'Токен не найден'
    return
  }
  try {
    const res = await fetch('/api/applicant/profile', {
      headers: { Authorization: `Bearer ${token.value}` }
    })
    if (res.ok) {
      applicant.value = await res.json()
    } else {
      message.value = 'Ошибка загрузки профиля'
    }
  } catch (e) {
    console.error('Ошибка загрузки профиля', e)
    message.value = 'Ошибка сети'
  }
}

const updateProfile = async () => {
  if (!token.value) {
    message.value = 'Токен не найден'
    return
  }
  try {
    const res = await fetch('/api/applicant/profile', {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${token.value}` },
      body: JSON.stringify(applicant.value)
    })
    if (res.ok) {
      message.value = 'Профиль успешно обновлён'
    } else {
      message.value = 'Ошибка при обновлении профиля'
    }
  } catch (e) {
    message.value = 'Ошибка сети'
  }
}

const fetchVacancies = async () => {
  if (!token.value) {
    message.value = 'Токен не найден'
    return
  }
  vacanciesLoading.value = true
  try {
    const res = await fetch('/api/applicant/vacancies', {
      headers: { Authorization: `Bearer ${token.value}` }
    })
    if (res.ok) {
      vacancies.value = await res.json()
    } else {
      message.value = 'Ошибка загрузки вакансий'
    }
  } catch (e) {
    console.error('Ошибка загрузки вакансий', e)
    message.value = 'Ошибка сети'
  } finally {
    vacanciesLoading.value = false
  }
}
</script>

<style scoped>
.applicant-profile {
  max-width: 600px;
  margin: 20px auto;
  font-family: Arial, sans-serif;
}
label {
  display: block;
  margin-top: 15px;
  font-weight: bold;
}
input {
  width: 100%;
  padding: 8px;
  margin-top: 5px;
  box-sizing: border-box;
}
button {
  margin-top: 20px;
  padding: 10px 15px;
  background-color: #3498db;
  color: white;
  border: none;
  border-radius: 6px;
  cursor: pointer;
}
.message {
  margin-top: 15px;
  color: green;
}
.vacancy-item {
  margin-bottom: 20px;
  border-bottom: 1px solid #ccc;
  padding-bottom: 10px;
}
</style>
