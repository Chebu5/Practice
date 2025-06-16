<template>
  <div class="pass-marks-form">
    <button @click="$emit('back')" class="back-link">← Назад к профилю</button>
    <h2>Проходные баллы ЕГЭ</h2>
    <div class="form-block">
      <div class="row">
        <label>ВУЗ:</label>
        <select v-model="selectedUniversity" @change="loadSpecializations" required>
          <option disabled value="">Выберите вуз</option>
          <option v-for="university in universities" :key="university.university_id" :value="university.university_id">
            {{ university.name }}
          </option>
        </select>
      </div>
    </div>
    <div v-if="specializations.length > 0" class="marks-result">
      <h3>Направления и проходные баллы:</h3>
      <ul>
        <li v-for="spec in specializations" :key="spec.specialization_id" class="spec-block">
          <strong>{{ spec.name }}</strong>
          <div v-if="spec.exams && spec.exams.length">
            <ul>
              <li v-for="exam in spec.exams" :key="exam.exam_name">
                {{ exam.exam_name }}: <b>{{ exam.pass_mark }}</b>
              </li>
            </ul>
          </div>
          <div v-else>
            Нет данных о проходных баллах по экзаменам
          </div>
        </li>
      </ul>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'

const universities = ref([])
const selectedUniversity = ref('')
const specializations = ref([])

onMounted(async () => {
  const res = await fetch('/api/universities')
  if (res.ok) universities.value = await res.json()
})

const loadSpecializations = async () => {
  specializations.value = []
  if (!selectedUniversity.value) return
  // Предполагается, что API возвращает массив специальностей с массивом exams
  const res = await fetch(`/api/universities/${selectedUniversity.value}/specializations`)
  if (res.ok) {
    specializations.value = await res.json()
  }
}
</script>

<style scoped>
.pass-marks-form {
  max-width: 600px;
  margin: 20px auto;
  padding: 20px;
}
.back-link {
  display: inline-block;
  margin-bottom: 20px;
  color: #3498db;
  background: none;
  border: none;
  font-size: 0.9em;
  cursor: pointer;
}
.form-block {
  border: 1px solid #eee;
  border-radius: 8px;
  padding: 20px;
  margin-bottom: 20px;
  background: #fafbfc;
}
.row {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 10px;
}
label {
  font-weight: bold;
  min-width: 120px;
}
input, select {
  padding: 8px;
  font-size: 1em;
  border-radius: 4px;
  border: 1px solid #ccc;
  flex: 1;
}
.marks-result {
  margin-top: 30px;
}
.spec-block {
  margin-bottom: 15px;
}
.marks-result ul {
  list-style: none;
  padding-left: 0;
}
</style>
