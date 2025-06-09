<template>
  <div class="vacancies-container">
    <h2>Вакансии</h2>

    <form @submit.prevent="submitVacancy" class="vacancy-form">
      <input v-model="title" placeholder="Название вакансии" required />

      <textarea v-model="description" placeholder="Описание вакансии"></textarea>

      <div class="salary-inputs">
        <input v-model.number="min_salary" type="number" placeholder="Мин. зарплата" />
        <input v-model.number="max_salary" type="number" placeholder="Макс. зарплата" />
      </div>

      <h3>Требования к образованию</h3>
      <div v-for="(req, index) in educationRequirements" :key="index" class="education-requirement">
        <select v-model="req.degree_level" required>
          <option>Бакалавр</option>
          <option>Магистр</option>
          <option>Специалитет</option>
        </select>
      </div>
      

      <h3>Навыки (ID через запятую)</h3>
      <input v-model="skillIdsInput" placeholder="1,2,3" />

      <button type="submit" class="save-btn">Создать вакансию</button>
    </form>

    <h3>Список вакансий</h3>
    <ul class="vacancy-list">
      <li v-for="vacancy in vacancies" :key="vacancy.vacancy_id" class="vacancy-item">
        <strong>{{ vacancy.title }}</strong> — {{ vacancy.description }}
        <button @click="deleteVacancy(vacancy.vacancy_id)" class="delete-btn">Удалить</button>
      </li>
    </ul>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'

const title = ref('')
const description = ref('')
const min_salary = ref(null)
const max_salary = ref(null)
const educationRequirements = ref([{ specialization_id: null, degree_level: 'Бакалавр' }])
const skillIdsInput = ref('')
const vacancies = ref([])
const specialty = ref('')
const requirements = ref('')
const token = localStorage.getItem('auth_token')

const fetchVacancies = async () => {
  const res = await fetch('/api/employer/vacancies', {
    headers: { Authorization: `Bearer ${token}` }
  })
  if (res.ok) vacancies.value = await res.json()
}
const submitVacancy = async () => {
  const skillIds = skillIdsInput.value.split(',').map(id => Number(id.trim())).filter(id => !isNaN(id))

  const specialtyValue = educationRequirements.value.length > 0 ? educationRequirements.value[0].degree_level : ''

  const payload = {
    title: title.value,
    description: description.value,
    min_salary: min_salary.value,
    max_salary: max_salary.value,
    specialty: specialtyValue,  // передаём уровень образования в specialty вакансии
    educationRequirements: educationRequirements.value,
    skillIds,
  }

  const res = await fetch('/api/employer/vacancies', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json', Authorization: `Bearer ${token}` },
    body: JSON.stringify(payload)
  })

  if (res.ok) {
    alert('Вакансия создана')
    title.value = ''
    description.value = ''
    min_salary.value = null
    max_salary.value = null
    educationRequirements.value = [{ specialization_id: null, degree_level: 'Бакалавр' }]
    skillIdsInput.value = ''
    fetchVacancies()
  } else {
    const data = await res.json()
    alert('Ошибка: ' + data.error)
  }
}

const deleteVacancy = async (vacancyId) => {
  if (!confirm('Вы уверены, что хотите удалить эту вакансию?')) return;

  try {
    const res = await fetch(`/api/employer/vacancies/${vacancyId}`, {
      method: 'DELETE',
      headers: { Authorization: `Bearer ${token}` }
    });

    if (res.ok) {
      alert('Вакансия удалена');
      vacancies.value = vacancies.value.filter(v => v.vacancy_id !== vacancyId);
    } else {
      const data = await res.json();
      alert('Ошибка при удалении: ' + (data.error || 'Неизвестная ошибка'));
    }
  } catch (err) {
    alert('Ошибка при удалении вакансии');
    console.error(err);
  }
}

onMounted(fetchVacancies)
</script>

<style scoped>
.vacancies-container {
  max-width: 700px;
  margin: 40px auto;
  padding: 25px;
  background: #f7f9fc;
  border-radius: 10px;
  box-shadow: 0 4px 12px rgba(0,0,0,0.1);
  font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
}

h2, h3 {
  color: #2c3e50;
  font-weight: 700;
  margin-bottom: 15px;
}

.vacancy-form {
  display: flex;
  flex-direction: column;
}

input, textarea, select {
  padding: 10px 12px;
  margin-bottom: 15px;
  border: 1.5px solid #bdc3c7;
  border-radius: 6px;
  font-size: 16px;
  transition: border-color 0.3s ease;
  font-family: inherit;
}

input:focus, textarea:focus, select:focus {
  outline: none;
  border-color: #3498db;
  box-shadow: 0 0 5px rgba(52, 152, 219, 0.5);
}

.salary-inputs {
  display: flex;
  gap: 15px;
}

.education-requirement {
  display: flex;
  gap: 10px;
  align-items: center;
  margin-bottom: 10px;
}

.remove-btn, .add-btn, .save-btn {
  padding: 10px 15px;
  border: none;
  border-radius: 6px;
  font-weight: 600;
  cursor: pointer;
  transition: background-color 0.3s ease;
  font-family: inherit;
}

.remove-btn {
  background-color: #e74c3c;
  color: white;
}

.remove-btn:hover {
  background-color: #c0392b;
}

.add-btn {
  background-color: #27ae60;
  color: white;
  width: fit-content;
  margin-bottom: 20px;
}

.add-btn:hover {
  background-color: #1e8449;
}

.save-btn {
  background-color: #3498db;
  color: white;
  margin-top: 10px;
}

.save-btn:hover {
  background-color: #2980b9;
}

.vacancy-list {
  list-style: none;
  padding-left: 0;
  margin-top: 20px;
}

.vacancy-item {
  background: white;
  padding: 15px 20px;
  border-radius: 8px;
  margin-bottom: 12px;
  box-shadow: 0 2px 6px rgba(0,0,0,0.08);
  color: #34495e;
  font-weight: 600;
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.delete-btn {
  background-color: #e74c3c;
  color: white;
  border: none;
  padding: 5px 10px;
  border-radius: 4px;
  cursor: pointer;
  font-weight: 600;
  transition: background-color 0.3s ease;
}

.delete-btn:hover {
  background-color: #c0392b;
}
</style>
