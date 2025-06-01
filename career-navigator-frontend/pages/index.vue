<template>
  <div>
    <h1>Личный кабинет работодателя</h1>

    <form @submit.prevent="addVacancy">
      <input v-model="title" placeholder="Название вакансии" required />
      <textarea v-model="description" placeholder="Описание" required></textarea>
      <button type="submit">Добавить вакансию</button>
    </form>

    <h2>Список вакансий</h2>
    <ul>
      <li v-for="vacancy in vacancies" :key="vacancy.id">
        <strong>{{ vacancy.title }}</strong>: {{ vacancy.description }}
      </li>
    </ul>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
const API_URL = '/api/vacancies'

const title = ref('')
const description = ref('')
const vacancies = ref([])

const fetchVacancies = async () => {
  try {
    const res = await fetch(API_URL);
    if (!res.ok) throw new Error('Failed to fetch');
    vacancies.value = await res.json();
  } catch (error) {
    console.error('Error fetching vacancies:', error);
  }
};

const addVacancy = async () => {
  try {
    const res = await fetch(API_URL, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ 
        title: title.value, 
        description: description.value 
      })
    });
    
    if (!res.ok) throw new Error('Failed to add vacancy');
    
    const newVacancy = await res.json();
    vacancies.value.push(newVacancy);
    title.value = '';
    description.value = '';
  } catch (error) {
    console.error('Error adding vacancy:', error);
  }
}

onMounted(fetchVacancies)
</script>
