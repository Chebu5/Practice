<template>
  <div class="university-profile">
    <template v-if="!showMessages">
      <h2>Профиль Вуза</h2>
      <form @submit.prevent="updateProfile">
        <label>Название вуза</label>
        <input v-model="university.name" required />
        <button type="submit">Сохранить</button>
      </form>
      <p v-if="message" class="message">{{ message }}</p>
      <button @click="showMessages = true" class="switch-btn">Перейти к сообщениям</button>
      <button @click="logout" class="logout-btn">Выйти</button>
    </template>
    <template v-else>
      <UniversityMessages />
      <button @click="showMessages = false" class="switch-btn">Назад к профилю</button>
      <button @click="logout" class="logout-btn">Выйти</button>
    </template>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import UniversityMessages from './UniversityMessages.vue' // путь укажите свой

const university = ref({
  name: '',
  phone: ''
})
const message = ref('')
const showMessages = ref(false)

const token = ref('')
const router = useRouter()

onMounted(() => {
  if (typeof window !== 'undefined') {
    token.value = localStorage.getItem('auth_token') || ''
    fetchProfile()
  }
})

const fetchProfile = async () => {
  try {
    if (!token.value) return
    const res = await fetch('/api/university/profile', {
      headers: { Authorization: `Bearer ${token.value}` }
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
    if (!token.value) return
    const res = await fetch('/api/university/profile', {
      method: 'PUT',
      headers: { 
        'Content-Type': 'application/json', 
        Authorization: `Bearer ${token.value}` 
      },
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

// Кнопка выхода
const logout = () => {
  if (typeof window !== 'undefined') {
    localStorage.removeItem('auth_token')
    router.push('/login')
  }
}
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
.switch-btn {
  margin-top: 15px;
  background-color: #5bc0de;
}
.logout-btn {
  margin-top: 15px;
  background-color: #e74c3c;
}
.message {
  margin-top: 15px;
  color: green;
}
</style>
