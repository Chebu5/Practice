<template>
  <div class="vacancies-page">
    <h2>Вакансии с требованиями к образованию</h2>
    <button @click="$emit('back')" class="back-link">← Назад к профилю</button>
    <div v-if="vacanciesLoading">Загрузка вакансий...</div>
    <div v-else>
      <div v-if="vacancies.length === 0">Вакансии не найдены</div>
      <ul>
        <li v-for="vacancy in vacancies" :key="vacancy.vacancy_id" class="vacancy-item">
          <h3>{{ vacancy.title }}</h3>
          <p><strong>Описание:</strong> {{ vacancy.description }}</p>
          <p><strong>Компания:</strong> {{ vacancy.employer.company_name }}</p>
          <div v-if="vacancy.educationRequirements.length">
            <h4>Требования к образованию:</h4>
            <ul>
              <li v-for="req in vacancy.educationRequirements" :key="req.requirement_id">
                Уровень: {{ req.degree_level }}
              </li>
            </ul>
          </div>
          <div v-if="vacancy.skills && vacancy.skills.length">
            <h4>Навыки:</h4>
            <ul>
              <li v-for="skill in vacancy.skills" :key="skill.skill_id">{{ skill.name }}</li>
            </ul>
          </div>
        </li>
      </ul>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'

const props = defineProps(['token'])
const emit = defineEmits(['back'])

const vacancies = ref([])
const vacanciesLoading = ref(false)

onMounted(async () => {
  await fetchVacancies()
})

const fetchVacancies = async () => {
  if (!props.token) return
  vacanciesLoading.value = true
  try {
    const res = await fetch('/api/applicant/vacancies', {
      headers: { Authorization: `Bearer ${props.token}` }
    })
    if (res.ok) {
      vacancies.value = await res.json()
    }
  } catch (e) {
    console.error('Ошибка загрузки вакансий', e)
  } finally {
    vacanciesLoading.value = false
  }
}
</script>

<style scoped>
.vacancies-page {
  max-width: 800px;
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
.vacancy-item {
  margin-bottom: 30px;
  padding: 20px;
  border: 1px solid #eee;
  border-radius: 8px;
  box-shadow: 0 2px 4px rgba(0,0,0,0.1);
}
.vacancies-page ul {
  list-style: none;
  padding-left: 0;
  margin-left: 0;
}

</style>
