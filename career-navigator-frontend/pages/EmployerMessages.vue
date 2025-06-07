<template>
  <div class="messages-container">
    <h2>Сообщения вузам</h2>

    <form @submit.prevent="sendMessage" class="message-form">
      <label for="university_id">Выберите вуз (ID)</label>
      <input v-model.number="university_id" id="university_id" required placeholder="ID вуза" />

      <label for="message">Сообщение</label>
      <textarea v-model="message" id="message" required placeholder="Текст сообщения"></textarea>

      <button type="submit" class="send-button">Отправить</button>
    </form>

    <h3>История сообщений</h3>
    <ul class="messages-list">
      <li v-for="msg in messages" :key="msg.message_id" class="message-item">
        <strong>Вуз ID: {{ msg.university_id }}</strong> — {{ msg.message }} —
        <span :class="{ 'status-sent': msg.status === 'Отправлено', 'status-received': msg.status === 'Получено' }">
          {{ msg.status }}
        </span> —
        {{ new Date(msg.created_at).toLocaleString() }}
      </li>
    </ul>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';

const university_id = ref(null);
const message = ref('');
const messages = ref([]);

const token = localStorage.getItem('auth_token');

const fetchMessages = async () => {
  try {
    const res = await fetch('/api/employer/messages', {
      headers: { Authorization: `Bearer ${token}` },
    });
    if (res.ok) {
      messages.value = await res.json();
    } else {
      alert('Ошибка загрузки сообщений');
    }
  } catch (error) {
    console.error('Ошибка при загрузке сообщений:', error);
    alert('Ошибка при загрузке сообщений: ' + error.message);
  }
};

const sendMessage = async () => {
  try {
    const res = await fetch('/api/employer/messages', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${token}` },
      body: JSON.stringify({ university_id: university_id.value, message: message.value }),
    });
    if (res.ok) {
      alert('Сообщение отправлено');
      message.value = '';
      university_id.value = null;
      await fetchMessages();
    } else {
      const data = await res.json();
      alert('Ошибка: ' + (data.error || 'Неизвестная ошибка'));
    }
  } catch (error) {
    console.error('Ошибка при отправке сообщения:', error);
    alert('Ошибка при отправке сообщения: ' + error.message);
  }
};

onMounted(fetchMessages);
</script>

<style scoped>
.messages-container {
  max-width: 800px;
  margin: 20px auto;
  padding: 30px;
  background: #f9f9f9;
  border-radius: 12px;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}

h2, h3 {
  color: #333;
  margin-bottom: 20px;
  text-align: center;
}

.message-form {
  display: flex;
  flex-direction: column;
  gap: 15px;
  margin-bottom: 30px;
}

label {
  font-weight: 500;
  color: #555;
}

input, textarea {
  padding: 12px;
  border: 1px solid #ddd;
  border-radius: 6px;
  font-size: 16px;
  color: #333;
  transition: border-color 0.3s ease;
}

input:focus, textarea:focus {
  outline: none;
  border-color: #5cb85c;
  box-shadow: 0 0 8px rgba(92, 184, 92, 0.3);
}

textarea {
  resize: vertical;
  min-height: 120px;
}

.send-button {
  padding: 14px 20px;
  background-color: #5cb85c;
  color: white;
  border: none;
  border-radius: 6px;
  font-size: 18px;
  font-weight: 600;
  cursor: pointer;
  transition: background-color 0.3s ease;
}

.send-button:hover {
  background-color: #449d44;
}

.messages-list {
  list-style: none;
  padding: 0;
}

.message-item {
  background: white;
  padding: 15px;
  border-radius: 8px;
  margin-bottom: 15px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.08);
  color: #444;
  font-size: 16px;
  line-height: 1.6;
  word-wrap: break-word;
}

.status-sent {
  color: #5bc0de;
}

.status-received {
  color: #f0ad4e;
}

.status-sent::before,
.status-received::before {
  display: inline-block;
  margin-right: 5px;
  font-size: 14px;
}

.status-sent::before {
  content: '✓';
}

.status-received::before {
  content: '!';
}
</style>
