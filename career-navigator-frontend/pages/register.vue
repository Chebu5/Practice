<template>
  <div class="auth-container">
    <h1>Регистрация</h1>
    <form @submit.prevent="handleRegister">
      <div class="form-group">
        <label for="email">Email</label>
        <input id="email" type="email" v-model="email" required placeholder="Введите email" />
      </div>

      <div class="form-group">
        <label for="password">Пароль</label>
        <input id="password" type="password" v-model="password" required placeholder="Введите пароль" />
      </div>

      <div class="form-group">
        <label for="confirmPassword">Подтверждение пароля</label>
        <input id="confirmPassword" type="password" v-model="confirmPassword" required placeholder="Повторите пароль" />
      </div>

      <div class="form-group">
        <label for="role">Роль</label>
        <select id="role" v-model="role" required>
          <option disabled value="">Выберите роль</option>
          <option value="employer">Работодатель</option>
          <option value="university">Вуз</option>
          <option value="applicant">Абитуриент</option>
        </select>
      </div>

      <button type="submit">Зарегистрироваться</button>
    </form>

    <p>
      Уже есть аккаунт?
      <router-link to="/login">Войти</router-link>
    </p>

    <p v-if="error" class="error-message">{{ error }}</p>
    <p v-if="success" class="success-message">{{ success }}</p>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'

const email = ref('')
const password = ref('')
const confirmPassword = ref('')
const role = ref('')
const error = ref('')
const success = ref('')
const router = useRouter()

const handleRegister = async () => {
  error.value = ''
  success.value = ''

  if (!email.value || !password.value || !confirmPassword.value || !role.value) {
    error.value = 'Пожалуйста, заполните все поля'
    return
  }

  if (password.value !== confirmPassword.value) {
    error.value = 'Пароли не совпадают'
    return
  }

  try {
    // TODO: заменить на вызов вашего API регистрации
    console.log('Регистрация:', { email: email.value, password: password.value, role: role.value })

    success.value = 'Регистрация прошла успешно! Вы можете войти.'
    // Очистка формы
    email.value = ''
    password.value = ''
    confirmPassword.value = ''
    role.value = ''
  } catch (e) {
    error.value = 'Ошибка регистрации: ' + (e.message || 'Неизвестная ошибка')
  }
}
</script>

<style scoped>
.auth-container {
  max-width: 400px;
  margin: 50px auto;
  padding: 25px;
  border: 1px solid #ddd;
  border-radius: 8px;
  background: #fff;
}

h1 {
  text-align: center;
  margin-bottom: 20px;
}

.form-group {
  margin-bottom: 15px;
}

label {
  display: block;
  margin-bottom: 6px;
  font-weight: 600;
}

input, select {
  width: 100%;
  padding: 8px;
  box-sizing: border-box;
}

button {
  width: 100%;
  padding: 10px;
  background: #27ae60;
  border: none;
  color: white;
  font-weight: 600;
  border-radius: 4px;
  cursor: pointer;
}

button:hover {
  background: #219150;
}

.error-message {
  margin-top: 15px;
  color: #e74c3c;
  font-weight: 600;
  text-align: center;
}

.success-message {
  margin-top: 15px;
  color: #27ae60;
  font-weight: 600;
  text-align: center;
}
</style>
