<template>
  <div class="applicant-profile">
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
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'

const applicant = ref({
  full_name: '',
  email: '',
  phone: ''
})
const message = ref('')
const token = localStorage.getItem('auth_token')

const fetchProfile = async () => {
  try {
    const res = await fetch('/api/applicant/profile', {
      headers: { Authorization: `Bearer ${token}` }
    })
    if (res.ok) {
      applicant.value = await res.json()
    }
  } catch (e) {
    console.error('Ошибка загрузки профиля', e)
  }
}

const updateProfile = async () => {
  try {
    const res = await fetch('/api/applicant/profile', {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${token}` },
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

onMounted(fetchProfile)
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
</style>
