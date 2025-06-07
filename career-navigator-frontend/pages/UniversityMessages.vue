<template>
  <div class="university-messages">
    <h2>Сообщения работодателям</h2>

    <form @submit.prevent="sendMessage">
      <label>Выберите работодателя (ID)</label>
      <input v-model.number="employer_id" required />

      <label>Сообщение</label>
      <textarea v-model="message" required></textarea>

      <button type="submit">Отправить</button>
    </form>

    <h3>История сообщений</h3>
    <ul>
      <li v-for="msg in messages" :key="msg.message_id">
        <strong>Работодатель ID: {{ msg.employer_id }}</strong> — {{ msg.message }} — {{ new Date(msg.created_at).toLocaleString() }}
      </li>
    </ul>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'

const employer_id = ref(null)
const message = ref('')
const messages = ref([])

const token = localStorage.getItem('auth_token')

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

const sendMessage = async () => {
  try {
    const res = await fetch('/api/university/messages', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${token}` },
      body: JSON.stringify({ employer_id: employer_id.value, message: message.value })
    })
    if (res.ok) {
      message.value = ''
      fetchMessages()
      alert('Сообщение отправлено')
    } else {
      alert('Ошибка отправки сообщения')
    }
  } catch (e) {
    alert('Ошибка сети')
  }
}

onMounted(fetchMessages)
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
input, textarea {
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
