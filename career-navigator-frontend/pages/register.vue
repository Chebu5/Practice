<template>
  <div class="auth-container">
    <h1>Регистрация</h1>

    <form @submit.prevent="handleRegister">
      <div class="form-group">
        <label>Роль</label>
        <select v-model="role" required>
          <option value="" disabled>Выберите роль</option>
          <option value="employer">Работодатель</option>
          <option value="applicant">Абитуриент</option>
          <option value="university">Вуз</option>
        </select>
      </div>

      <div v-if="role === 'employer'">
        <div class="form-group">
          <label for="companyName">Название компании</label>
          <input id="companyName" type="text" v-model.trim="companyName" required placeholder="Введите название компании" />
        </div>
        <div class="form-group">
          <label for="contactPhone">Телефон</label>
          <input id="contactPhone" type="tel" v-model.trim="contactPhone" placeholder="Введите телефон" />
        </div>
      </div>

      <div v-if="role === 'applicant'">
        <div class="form-group">
          <label for="fullName">ФИО</label>
          <input id="fullName" type="text" v-model.trim="fullName" required placeholder="Введите полное имя" />
        </div>
        <div class="form-group">
          <label for="phone">Телефон</label>
          <input id="phone" type="tel" v-model.trim="phone" placeholder="Введите телефон" />
        </div>
      </div>

      <div v-if="role === 'university'">
        <div class="form-group">
          <label for="universityName">Название вуза</label>
          <input id="universityName" type="text" v-model.trim="universityName" required placeholder="Введите название вуза" />
        </div>
      </div>

      <div class="form-group">
        <label for="email">Email</label>
        <input id="email" type="email" v-model.trim="email" required placeholder="Введите email" />
      </div>

      <!-- Пароль и подтверждение пароля для всех ролей -->
      <div v-if="role">
        <div class="form-group">
          <label for="password">Пароль</label>
          <input id="password" type="password" v-model="password" required placeholder="Введите пароль" />
        </div>

        <div class="form-group">
          <label for="confirmPassword">Подтверждение пароля</label>
          <input id="confirmPassword" type="password" v-model="confirmPassword" required placeholder="Повторите пароль" />
        </div>
      </div>

      <button type="submit" :disabled="loading">
        <span v-if="loading">Регистрация...</span>
        <span v-else>Зарегистрироваться</span>
      </button>
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

const role = ref('')
const companyName = ref('')
const contactPhone = ref('')
const fullName = ref('')
const phone = ref('')
const universityName = ref('')
const email = ref('')
const password = ref('')
const confirmPassword = ref('')
const error = ref('')
const success = ref('')
const loading = ref(false)
const router = useRouter()

const validateEmail = (email) => /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)

const handleRegister = async () => {
  error.value = ''
  success.value = ''

  if (!role.value) {
    error.value = 'Выберите роль'
    return
  }

  if (role.value === 'employer' && !companyName.value) {
    error.value = 'Введите название компании'
    return
  }

  if (role.value === 'applicant' && !fullName.value) {
    error.value = 'Введите полное имя'
    return
  }

  if (role.value === 'university' && !universityName.value) {
    error.value = 'Введите название вуза'
    return
  }

  if (!email.value) {
    error.value = 'Введите email'
    return
  }

  if (!validateEmail(email.value)) {
    error.value = 'Введите корректный email'
    return
  }

  // Пароль обязателен для всех ролей
  if (!password.value || !confirmPassword.value) {
    error.value = 'Введите пароль и подтвердите его'
    return
  }

  if (password.value !== confirmPassword.value) {
    error.value = 'Пароли не совпадают'
    return
  }

  if (password.value.length < 6) {
    error.value = 'Пароль должен быть не менее 6 символов'
    return
  }

  loading.value = true

  try {
    const payload = {
      role: role.value,
      email: email.value,
      password: password.value,
    }

    if (role.value === 'employer') {
      payload.company_name = companyName.value
      payload.contact_phone = contactPhone.value || null
    } else if (role.value === 'applicant') {
      payload.full_name = fullName.value
      payload.phone = phone.value || null
    } else if (role.value === 'university') {
      payload.university_name = universityName.value
    }

    const response = await fetch('http://localhost:3001/api/register', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload),
    })

    const data = await response.json()

    if (!response.ok) {
      error.value = data.error || 'Ошибка регистрации'
      loading.value = false
      return
    }

    success.value = 'Регистрация прошла успешно! Вы можете войти.'
    // Очистка формы
    role.value = ''
    companyName.value = ''
    contactPhone.value = ''
    fullName.value = ''
    phone.value = ''
    universityName.value = ''
    email.value = ''
    password.value = ''
    confirmPassword.value = ''
  } catch (e) {
    error.value = 'Ошибка регистрации: ' + (e.message || 'Неизвестная ошибка')
  } finally {
    loading.value = false
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

button:disabled {
  background: #7f8c8d;
  cursor: not-allowed;
}

button:hover:not(:disabled) {
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
