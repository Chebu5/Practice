<template>
  <div class="auth-container">
    <h1>Вход в систему</h1>
    <form @submit.prevent="handleLogin">
      <div class="form-group">
        <label>Роль</label>
        <select v-model="role" required>
          <option value="" disabled>Выберите роль</option>
          <option value="employer">Работодатель</option>
          <option value="applicant">Абитуриент</option>
          <option value="university">Вуз</option>
        </select>
      </div>

      <div class="form-group">
        <label for="email">Email</label>
        <input id="email" type="email" v-model="email" required placeholder="Введите email" />
      </div>

      <!-- Пароль теперь для всех ролей -->
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

const role = ref('')
const email = ref('')
const password = ref('')
const error = ref('')
const router = useRouter()

const handleLogin = async () => {
  error.value = ''

  if (!role.value) {
    error.value = 'Выберите роль'
    return
  }

  if (!email.value || !password.value) {
    error.value = 'Пожалуйста, заполните все поля'
    return
  }

  try {
    const payload = {
      role: role.value,
      email: email.value,
      password: password.value,
    }

    const response = await fetch('http://localhost:3001/api/login', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload),
    })

    const data = await response.json()

    if (!response.ok) {
      error.value = data.error || 'Неверный email или пароль'
      return
    }

    if (data.token) {
      localStorage.setItem('auth_token', data.token)
      localStorage.setItem('role', role.value)

      // Перенаправление в зависимости от роли
      switch (role.value) {
        case 'employer':
          await router.push('/')
          break
        case 'university':
          await router.push('/UniversityProfile')
          break
        case 'applicant':
          await router.push('/ApplicantProfile')
          break
        default:
          await router.push('/')
      }
    }
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
