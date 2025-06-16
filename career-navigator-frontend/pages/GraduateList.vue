<template>
  <div class="graduates-container">
    <h2>Профили выпускников</h2>
    <div class="filters">
      <label>Фильтр по вузу</label>
      <select v-model.number="filterUniversityId">
        <option value="">Все вузы</option>
        <option v-for="u in universities" :key="u.university_id" :value="u.university_id">
          {{ u.name }}
        </option>
      </select>
      <button @click="fetchGraduates" :disabled="loading">
        {{ loading ? 'Загрузка...' : 'Поиск' }}
      </button>
    </div>
    <ul class="graduates-list">
      <li v-for="graduate in graduates" :key="graduate.graduate_id" class="graduate-item">
        <strong>{{ graduate.full_name }}</strong><br>
        <span>Вуз: {{ graduate.university?.name || graduate.university_id }}</span><br>
        <span>Специальность: {{ graduate.specialty }}</span><br>
        <span>Email: {{ graduate.contact_email }}</span><br>
        <span>Телефон: {{ graduate.contact_phone }}</span>
      </li>
    </ul>
    <div v-if="error" class="error">{{ error }}</div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'

const graduates = ref([])
const filterUniversityId = ref('')
const loading = ref(false)
const error = ref(null)
const universities = ref([])

const token = localStorage.getItem('auth_token')

const fetchUniversities = async () => {
  try {
    const res = await fetch('/api/universities')
    if (res.ok) {
      universities.value = await res.json()
    }
  } catch (e) {}
}

const fetchGraduates = async () => {
  loading.value = true
  error.value = null
  const params = new URLSearchParams()
  if (filterUniversityId.value) params.append('university_id', filterUniversityId.value)

  try {
    const res = await fetch('/api/graduates?' + params.toString(), {
      headers: { Authorization: `Bearer ${token}` }
    })
    if (res.ok) {
      graduates.value = await res.json()
    } else {
      error.value = 'Ошибка загрузки выпускников'
    }
  } catch (e) {
    error.value = 'Ошибка сети или сервера'
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  fetchUniversities()
  fetchGraduates()
})
</script>
<style scoped>
.graduates-container {
  max-width: 700px;
  margin: 30px auto;
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
  padding: 20px;
  background: #f9f9f9;
  border-radius: 10px;
}

.filters {
  display: flex;
  flex-wrap: wrap;
  gap: 10px;
  margin-bottom: 20px;
  align-items: flex-end;
}

.filters label {
  flex-basis: 100%;
  font-weight: 600;
  margin-bottom: 5px;
  color: #333;
}

.filters select {
  padding: 8px 10px;
  border: 1px solid #ccc;
  border-radius: 6px;
  font-size: 16px;
  flex-grow: 1;
}

.filters button {
  padding: 10px 20px;
  background-color: #3498db;
  border: none;
  color: white;
  font-weight: 600;
  border-radius: 6px;
  cursor: pointer;
  transition: background-color 0.3s ease;
}

.filters button:disabled {
  background-color: #7fb3d5;
  cursor: not-allowed;
}

.filters button:hover:not(:disabled) {
  background-color: #2980b9;
}

.graduates-list {
  list-style: none;
  padding-left: 0;
}

.graduate-item {
  background: white;
  padding: 12px 15px;
  margin-bottom: 10px;
  border-radius: 8px;
  box-shadow: 0 2px 6px rgba(0,0,0,0.08);
  color: #2c3e50;
  font-weight: 600;
}

.error {
  color: red;
  margin-top: 15px;
  font-weight: 600;
}
</style>
