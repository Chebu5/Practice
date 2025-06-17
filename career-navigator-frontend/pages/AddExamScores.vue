<template>
  <div class="add-exam-scores">
    <h2>Добавить экзамен для специальности</h2>
    <form @submit.prevent="submitScores">
      <label>Специальность</label>
      <select v-model="specializationId" required>
  <option value="" disabled>Выберите специальность</option>
  <option v-for="spec in specializations" :key="spec.specialization_id" :value="spec.specialization_id">
    {{ spec.name }}
  </option>
</select>


      <label>Экзамен</label>
      <select v-model="examName" required>
        <option value="" disabled>Выберите экзамен</option>
        <option v-for="exam in exams" :key="exam" :value="exam">
          {{ exam }}
        </option>
      </select>

      <label>Проходной балл</label>
      <input v-model.number="score" type="number" min="0" max="100" required />

      <button type="submit">Добавить</button>
    </form>
    <p v-if="message" class="message">{{ message }}</p>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'

const exams = [
  'Информатика',
  'Физика',
  'Математика',
  'Химия',
  'Иностранный',
  'Русский язык',
  'История',
  'Обществознание',
  'География'
]

const specializationId = ref('')
const examName = ref('')
const score = ref(null)
const message = ref('')
const specializations = ref([])

const token = localStorage.getItem('auth_token')

// Получить university_id из токена (JWT)
function getUniversityIdFromToken(token) {
  try {
    const payload = JSON.parse(atob(token.split('.')[1]))
    return payload.university_id
  } catch {
    return null
  }
}

// Загрузить специализации для текущего университета
const fetchSpecializations = async () => {
  try {
    const res = await fetch('/api/specializations')
    if (res.ok) {
      specializations.value = await res.json()
    } else {
      message.value = 'Ошибка загрузки специальностей'
    }
  } catch (e) {
    message.value = 'Ошибка сети при загрузке специальностей'
  }
}

const submitScores = async () => {
  message.value = ''
  try {
    const res = await fetch('/api/university/exams', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${token}`
      },
      body: JSON.stringify({
        specialization_id: specializationId.value,
        exam_name: examName.value,
        pass_mark: score.value
      })
    })
    const data = await res.json()
    if (res.ok) {
      message.value = data.message || 'Экзамен успешно добавлен!'
      specializationId.value = ''
      examName.value = ''
      score.value = null
    } else {
      message.value = data.error || 'Ошибка добавления'
    }
  } catch (e) {
    message.value = 'Ошибка сети'
  }
}

onMounted(fetchSpecializations)
</script>

<style scoped>
.add-exam-scores {
  max-width: 400px;
  margin: 0 auto;
}
label {
  display: block;
  margin-top: 15px;
  font-weight: bold;
}
input, select {
  width: 100%;
  padding: 8px;
  margin-top: 5px;
  box-sizing: border-box;
}
button {
  margin-top: 20px;
  padding: 10px 15px;
  background-color: #27ae60;
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
