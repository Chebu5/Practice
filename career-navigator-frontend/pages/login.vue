<template>
  <div class="auth-container">
    <h1>Вход в систему</h1>
    <form @submit.prevent="handleLogin">
      <div class="form-group">
        <label for="email">Email</label>
        <input id="email" type="email" v-model="email" required placeholder="Введите email" />
      </div>

      <div class="form-group">
        <label for="password">Пароль</label>
        <input id="password" type="password" v-model="password" required placeholder="Введите пароль" />
      </div>

      <button type="submit">Войти</button>
    </form>

    <p>
      Нет аккаунта?
      <router-link to="/register">Зарегистрироваться</router-link>
    </p>

    <p v-if="error" class="error-message">{{ error }}</p>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'

const email = ref('')
const password = ref('')
const error = ref('')
const router = useRouter()

const handleLogin = async () => {
  error.value = ''
  try {
    // TODO: заменить на вызов вашего API авторизации
    if (!email.value || !password.value) {
      error.value = 'Пожалуйста, заполните все поля'
      return
    }
    // Пример успешного входа:
    console.log('Логин:', email.value, password.value)
    // После успешного входа редирект на главную или личный кабинет
    router.push('/')
  } catch (e) {
    error.value = 'Ошибка входа: ' + (e.message || 'Неизвестная ошибка')
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

input {
  width: 100%;
  padding: 8px;
  box-sizing: border-box;
}

button {
  width: 100%;
  padding: 10px;
  background: #3498db;
  border: none;
  color: white;
  font-weight: 600;
  border-radius: 4px;
  cursor: pointer;
}

button:hover {
  background: #2980b9;
}

.error-message {
  margin-top: 15px;
  color: #e74c3c;
  font-weight: 600;
  text-align: center;
}
</style>
