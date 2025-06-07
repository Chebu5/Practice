<template>
  <div class="profile-container">
    <h2>Профиль работодателя</h2>
    <form @submit.prevent="updateProfile" class="profile-form">
      <label for="company_name">Название компании</label>
      <input id="company_name" v-model="company_name" required placeholder="Введите название компании" />

      <label for="contact_phone">Контактный телефон</label>
      <input id="contact_phone" v-model="contact_phone" placeholder="Введите контактный телефон" />

      <button type="submit" class="save-button">Сохранить</button>
    </form>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'

const company_name = ref('')
const contact_phone = ref('')

const fetchProfile = async () => {
  const token = localStorage.getItem('auth_token')
  const res = await fetch('/api/employer/profile', {
    headers: { Authorization: `Bearer ${token}` }
  })
  if (res.ok) {
    const data = await res.json()
    company_name.value = data.company_name
    contact_phone.value = data.contact_phone
  }
}

const updateProfile = async () => {
  const token = localStorage.getItem('auth_token')
  const res = await fetch('/api/employer/profile', {
    method: 'PUT',
    headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${token}` },
    body: JSON.stringify({ company_name: company_name.value, contact_phone: contact_phone.value })
  })
  if (res.ok) alert('Профиль обновлен')
  else alert('Ошибка при обновлении')
}

onMounted(fetchProfile)
</script>

<style scoped>
.profile-container {
  max-width: 500px;
  margin: 40px auto;
  padding: 30px 25px;
  background-color: #f7f9fc;
  border-radius: 10px;
  box-shadow: 0 4px 12px rgba(0,0,0,0.1);
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}

h2 {
  text-align: center;
  margin-bottom: 25px;
  color: #2c3e50;
  font-weight: 700;
  font-size: 28px;
}

.profile-form {
  display: flex;
  flex-direction: column;
}

label {
  margin-bottom: 8px;
  font-weight: 600;
  color: #34495e;
}

input {
  padding: 10px 12px;
  margin-bottom: 20px;
  border: 1.5px solid #bdc3c7;
  border-radius: 6px;
  font-size: 16px;
  transition: border-color 0.3s ease;
}

input:focus {
  outline: none;
  border-color: #3498db;
  box-shadow: 0 0 5px rgba(52, 152, 219, 0.5);
}

.save-button {
  padding: 12px;
  background-color: #3498db;
  border: none;
  border-radius: 6px;
  color: white;
  font-weight: 700;
  font-size: 18px;
  cursor: pointer;
  transition: background-color 0.3s ease;
}

.save-button:hover {
  background-color: #2980b9;
}
</style>
