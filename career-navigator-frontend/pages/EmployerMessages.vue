<template>
  <div class="messages-container">
    <h2>Сообщения вузам</h2>

    <form @submit.prevent="sendMessage" class="message-form">
      <label>Выберите вуз:</label>
      <select v-model="selectedUniversityId" required>
        <option disabled value="">Выберите вуз из списка</option>
        <option
          v-for="university in universities"
          :key="university.university_id"
          :value="university.university_id"
        >
          {{ university.name }}
        </option>
      </select>

      <label for="message">Сообщение</label>
      <textarea v-model="message" id="message" required placeholder="Текст сообщения"></textarea>

      <button type="submit" class="send-button">Отправить</button>
    </form>

    <h3>История сообщений</h3>
    <ul class="messages-list">
      <li v-for="msg in messages" :key="msg.message_id" class="message-item">
        <strong>{{ getUniversityName(msg.university_id) }}</strong> — {{ msg.message }} —
        <span :class="{ 'status-sent': msg.status === 'sent', 'status-received': msg.status === 'received' }">
          {{ msg.status === 'sent' ? 'Отправлено' : msg.status === 'received' ? 'Получено' : msg.status }}
        </span> —
        {{ new Date(msg.created_at).toLocaleString() }}
      </li>
    </ul>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';

const selectedUniversityId = ref('');
const message = ref('');
const messages = ref([]);
const universities = ref([]);

const token = localStorage.getItem('auth_token');

// Загрузка списка вузов
const fetchUniversities = async () => {
  try {
    const res = await fetch('/api/universities');
    if (res.ok) {
      universities.value = await res.json();
    }
  } catch (error) {
    console.error('Ошибка загрузки вузов:', error);
  }
};

// Получение названия вуза по ID
const getUniversityName = (id) => {
  const university = universities.value.find(u => u.university_id === id);
  return university ? university.name : `Вуз ID: ${id}`;
};

// Загрузка истории сообщений
const fetchMessages = async () => {
  try {
    const res = await fetch('/api/employer/messages', {
      headers: { Authorization: `Bearer ${token}` },
    });
    if (res.ok) {
      messages.value = await res.json();
    }
  } catch (error) {
    console.error('Ошибка загрузки сообщений:', error);
  }
};

// Отправка сообщения
const sendMessage = async () => {
  try {
    const res = await fetch('/api/employer/messages', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${token}`
      },
      body: JSON.stringify({
        university_id: selectedUniversityId.value,
        message: message.value
      }),
    });

    if (res.ok) {
      message.value = '';
      selectedUniversityId.value = '';
      await fetchMessages();
    } else {
      const data = await res.json();
      alert('Ошибка: ' + (data.error || 'Неизвестная ошибка'));
    }
  } catch (error) {
    console.error('Ошибка при отправке сообщения:', error);
  }
};

// Загрузка данных при монтировании компонента
onMounted(() => {
  fetchUniversities();
  fetchMessages();
});
</script>

<style scoped>
select {
  padding: 12px;
  border: 1px solid #ddd;
  border-radius: 6px;
  font-size: 16px;
  width: 100%;
  margin-bottom: 15px;
  background-color: white;
  appearance: none;
  background-image: url("data:image/svg+xml;charset=US-ASCII,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%22292.4%22%20height%3D%22292.4%22%3E%3Cpath%20fill%3D%22%23333%22%20d%3D%22M287%2069.4a17.6%2017.6%200%200%200-13-5.4H18.4c-5%200-9.3%201.8-12.9%205.4A17.6%2017.6%200%200%200%200%2082.2c0%205%201.8%209.3%205.4%2012.9l128%20127.9c3.6%203.6%207.8%205.4%2012.8%205.4s9.2-1.8%2012.8-5.4L287%2095c3.5-3.5%205.4-7.8%205.4-12.8%200-5-1.9-9.2-5.5-12.8z%22%2F%3E%3C%2Fsvg%3E");
  background-repeat: no-repeat;
  background-position: right 10px center;
  background-size: 12px auto;
}

select:focus {
  outline: none;
  border-color: #5cb85c;
  box-shadow: 0 0 8px rgba(92, 184, 92, 0.3);
}

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
