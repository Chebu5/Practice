<template>
  <div class="university-profile">
    <h2>Профиль Вуза</h2>
    <form @submit.prevent="updateProfile">
      <label>Название вуза</label>
      <input v-model="university.name" required />

      <label>Адрес</label>
      <input v-model="university.address" />

      <label>Контактный телефон</label>
      <input v-model="university.phone" />

      <button type="submit">Сохранить</button>
    </form>
    <p v-if="message" class="message">{{ message }}</p>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'

const university = ref({
  name: '',
  address: '',
  phone: ''
})
const message = ref('')
const token = localStorage.getItem('auth_token')

const fetchProfile = async () => {
  try {
    const res = await fetch('/api/university/profile', {
      headers: { Authorization: `Bearer ${token}` }
    })
    if (res.ok) {
      const data = await res.json()
      university.value = data
    }
  } catch (e) {
    console.error('Ошибка загрузки профиля', e)
  }
}

const updateProfile = async () => {
  try {
    const res = await fetch('/api/university/profile', {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${token}` },
      body: JSON.stringify(university.value)
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
.university-profile {
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
