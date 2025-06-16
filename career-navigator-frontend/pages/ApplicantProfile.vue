<template>
  <div>
    <!-- Профиль абитуриента -->
    <div v-if="!showVacancies && !showPassMarks" class="applicant-profile">
      <button @click="logout">Выход</button>
      <h2>Профиль абитуриента</h2>
      <form @submit.prevent="updateProfile">
        <label>ФИО</label>
        <input v-model="applicant.full_name" required />

        <label>Email</label>
        <input v-model="applicant.email" type="email" disabled />

        <label>Телефон</label>
        <input v-model="applicant.phone" />

        <label>ВУЗ</label>
        <select v-model="applicant.university_id" required>
          <option v-if="universitiesLoading" disabled>Загрузка вузов...</option>
          <option 
            v-for="university in universities" 
            :key="university.university_id" 
            :value="university.university_id"
          >
            {{ university.name }}
          </option>
        </select>

        <label>Специальность</label>
        <select v-model="applicant.specialization_id" required :disabled="specializationsLoading || specializations.length === 0">
          <option v-if="specializationsLoading" disabled>Загрузка специальностей...</option>
          <option 
            v-for="specialization in specializations" 
            :key="specialization.specialization_id" 
            :value="specialization.specialization_id"
          >
            {{ specialization.name }}
          </option>
        </select>

        <button type="submit">Сохранить</button>
      </form>
      <p v-if="message" class="message">{{ message }}</p>
      <hr />
      <div class="navigation-buttons">
        <button class="nav-button" @click="showVacancies = true">
          Просмотреть все вакансии
        </button>
        <button class="nav-button" @click="showPassMarks = true">
    ВУЗ
  </button>
      </div>
    </div>
    <!-- Список вакансий -->
    <VacanciesPage
  v-if="showVacancies"
  :token="token"
  @back="showVacancies = false"
/>

<!-- Фрагмент с проходными баллами -->
<PassMarksForm
  v-if="showPassMarks"
  @back="showPassMarks = false"
/>
  </div>
</template>

<script setup>
import { ref, onMounted, watch } from 'vue'
import { useRouter } from 'vue-router'
import VacanciesPage from './VacanciesPage.vue'
import PassMarksForm from './PassMarksForm.vue'


const applicant = ref({
  full_name: '',
  email: '',
  phone: '',
  university_id: null,
  specialization_id: null
})

const message = ref('')
const token = ref('')
const showVacancies = ref(false)
const showPassMarks = ref(false)


const universities = ref([])
const specializations = ref([])
const universitiesLoading = ref(false)
const specializationsLoading = ref(false)

const router = useRouter()

onMounted(() => {
  token.value = localStorage.getItem('auth_token')
  fetchProfile()
  fetchUniversities()
})

watch(() => applicant.value.university_id, async (newUniversityId) => {
  if (!newUniversityId) {
    specializations.value = []
    applicant.value.specialization_id = null
    return
  }
  specializationsLoading.value = true
  try {
    const res = await fetch(`/api/universities/${newUniversityId}/specializations`, {
      headers: { Authorization: `Bearer ${token.value}` }
    })
    if (res.ok) {
      specializations.value = await res.json()
      if (!specializations.value.find(s => s.specialization_id === applicant.value.specialization_id)) {
        applicant.value.specialization_id = null
      }
    } else {
      specializations.value = []
      applicant.value.specialization_id = null
    }
  } catch (e) {
    console.error('Ошибка загрузки специальностей для вуза', e)
    specializations.value = []
    applicant.value.specialization_id = null
  } finally {
    specializationsLoading.value = false
  }
})

const logout = () => {
  localStorage.removeItem('auth_token')
  token.value = ''
  router.push('/login')
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

const fetchUniversities = async () => {
  universitiesLoading.value = true
  try {
    const res = await fetch('/api/universities', {
      headers: { Authorization: `Bearer ${token.value}` }
    })
    if (res.ok) {
      universities.value = await res.json()
    }
  } catch (e) {
    console.error('Ошибка загрузки вузов:', e)
  } finally {
    universitiesLoading.value = false
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
input, select {
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
.navigation-buttons {
  margin-top: 30px;
  text-align: center;
}
.nav-button {
  display: inline-block;
  padding: 12px 25px;
  background-color: #2ecc71;
  color: white;
  text-decoration: none;
  border-radius: 6px;
  transition: background-color 0.3s;
}
.nav-button:hover {
  background-color: #27ae60;
}
</style>
