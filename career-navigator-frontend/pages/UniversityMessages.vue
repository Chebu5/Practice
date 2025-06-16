<template>
  <div class="university-messages">
    <h2>Сообщения работодателям</h2>

    <form @submit.prevent="sendMessage">
      <label>Выберите работодателя:</label>
      <select v-model="selectedEmployerId" required>
        <option disabled value="">Выберите работодателя</option>
        <option v-for="emp in employers" :key="emp.employer_id" :value="emp.employer_id">
          {{ emp.company_name }}
        </option>
      </select>

      <label>Сообщение</label>
      <textarea v-model="message" required></textarea>

      <button type="submit">Отправить</button>
    </form>

    <h3>История сообщений</h3>
    <ul>
      <li v-for="msg in messages" :key="msg.message_id">
        <strong>Работодатель: {{ getEmployerName(msg.employer_id) }}</strong> — {{ msg.message }} — {{ new Date(msg.created_at).toLocaleString() }}
      </li>
    </ul>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'

const selectedEmployerId = ref('')
const message = ref('')
const messages = ref([])
const employers = ref([])

const token = localStorage.getItem('auth_token')

// Загрузить список работодателей
const fetchEmployers = async () => {
  try {
    const res = await fetch('/api/employers')
    if (res.ok) {
      employers.value = await res.json()
    }
  } catch (e) {
    console.error('Ошибка загрузки работодателей', e)
  }
}

// Получить название работодателя по ID
const getEmployerName = (id) => {
  const emp = employers.value.find(e => e.employer_id === id)
  return emp ? `${emp.company_name} (ID: ${emp.employer_id})` : `ID: ${id}`
}

// Загрузить историю сообщений
const fetchMessages = async () => {
  try {
    const res = await fetch('/api/university/messages', {
      headers: { Authorization: `Bearer ${token}` }
    })
    if (res.ok) messages.value = await res.json()
  } catch (e) {
    console.error('Ошибка загрузки сообщений', e)
  }
}

// Отправить сообщение
const sendMessage = async () => {
  try {
    const res = await fetch('/api/university/messages', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${token}` },
      body: JSON.stringify({ employer_id: selectedEmployerId.value, message: message.value })
    })
    if (res.ok) {
      message.value = ''
      selectedEmployerId.value = ''
      fetchMessages()
      alert('Сообщение отправлено')
    } else {
      alert('Ошибка отправки сообщения')
    }
  } catch (e) {
    alert('Ошибка сети')
  }
}

onMounted(() => {
  fetchEmployers()
  fetchMessages()
})
</script>

<style scoped>
.university-messages {
  max-width: 700px;
  margin: 20px auto;
  font-family: Arial, sans-serif;
}
label {
  display: block;
  margin-top: 15px;
  font-weight: bold;
}
input, textarea, select {
  width: 100%;
  padding: 8px;
  margin-top: 5px;
  box-sizing: border-box;
}
button {
  margin-top: 15px;
  padding: 10px 15px;
  background-color: #27ae60;
  color: white;
  border: none;
  border-radius: 6px;
  cursor: pointer;
}
ul {
  margin-top: 25px;
  padding-left: 0;
  list-style: none;
}
li {
  padding: 10px;
  background: #f0f0f0;
  margin-bottom: 10px;
  border-radius: 6px;
}
</style>
