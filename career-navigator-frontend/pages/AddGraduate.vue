<template>
  <div class="add-graduate">
    <h2>Добавить выпускника</h2>
    <form @submit.prevent="submitGraduate">
      <label>ФИО</label>
      <input v-model="fullName" required />

      <label>Специальность</label>
      <input v-model="specialty" required />

      <label>Email</label>
      <input v-model="email" type="email" required />

      <label>Телефон</label>
      <input v-model="phone" required />

      <button type="submit">Добавить</button>
    </form>
    <p v-if="message" class="message">{{ message }}</p>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const fullName = ref('')
const specialty = ref('')
const email = ref('')
const phone = ref('')
const message = ref('')

const submitGraduate = async () => {
  // Здесь должен быть реальный запрос на backend (например, /api/graduates)
  // Пример заглушки:
  message.value = `Выпускник ${fullName.value} успешно добавлен!`
  fullName.value = ''
  specialty.value = ''
  email.value = ''
  phone.value = ''
}
</script>

<style scoped>
.add-graduate {
  max-width: 400px;
  margin: 0 auto;
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
  background-color: #5bc0de;
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
