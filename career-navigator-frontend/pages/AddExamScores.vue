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

    <h3>Текущие экзамены для специальностей</h3>
    <div v-if="examsList.length === 0" class="exam-list-empty">Нет добавленных экзаменов.</div>
    <ul v-else class="exam-list">
      <li v-for="exam in examsList" :key="exam.specialization_id + '-' + exam.exam_name">
        <strong>
          {{ getSpecName(exam.specialization_id) }} — {{ exam.exam_name }}
        </strong>
        <span>Проходной балл: </span>
        <input
          v-model.number="exam.editPassMark"
          type="number"
          min="0"
          max="100"
          style="width:60px"
        />
        <button @click="updateExam(exam)">Сохранить</button>
        <button @click="deleteExam(exam)" class="delete-btn">Удалить</button>
      </li>
    </ul>
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
const examsList = ref([])

const token = localStorage.getItem('auth_token')

// Получить список всех специальностей
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

// Получить текущие экзамены для вуза
const fetchExams = async () => {
  try {
    const res = await fetch('/api/university/exams', {
      headers: { Authorization: `Bearer ${token}` }
    });
    if (res.ok) {
      const data = await res.json();
      examsList.value = data.map(e => ({ ...e, editPassMark: e.pass_mark }));
    }
  } catch (e) {
    // обработка ошибки
  }
};

const getSpecName = (id) => {
  const spec = specializations.value.find(s => s.specialization_id === id);
  return spec ? spec.name : id;
};

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
      fetchExams()
    } else {
      message.value = data.error || 'Ошибка добавления'
    }
  } catch (e) {
    message.value = 'Ошибка сети'
  }
}

const updateExam = async (exam) => {
  try {
    const res = await fetch('/api/university/exams', {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${token}`
      },
      body: JSON.stringify({
        specialization_id: exam.specialization_id,
        exam_name: exam.exam_name,
        pass_mark: exam.editPassMark
      })
    });
    const data = await res.json();
    if (res.ok) {
      exam.pass_mark = exam.editPassMark;
      message.value = data.message || 'Экзамен обновлён!';
    } else {
      message.value = data.error || 'Ошибка обновления';
    }
  } catch (e) {
    message.value = 'Ошибка сети';
  }
};

const deleteExam = async (exam) => {
  if (!confirm('Удалить этот экзамен?')) return;
  try {
    const res = await fetch(
      `/api/university/exams?specialization_id=${exam.specialization_id}&exam_name=${encodeURIComponent(exam.exam_name)}`,
      {
        method: 'DELETE',
        headers: {
          Authorization: `Bearer ${token}`
        }
      }
    );
    const data = await res.json();
    if (res.ok) {
      message.value = data.message || 'Экзамен удалён!';
      fetchExams();
    } else {
      message.value = data.error || 'Ошибка удаления';
    }
  } catch (e) {
    message.value = 'Ошибка сети';
  }
};

onMounted(() => {
  fetchSpecializations();
  fetchExams();
});
</script>

<style scoped>
.add-exam-scores {
  max-width: 500px;
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
.exam-list {
  margin-top: 30px;
  padding-left: 0;
  list-style: none;
}
.exam-list li {
  background: #f9f9f9;
  margin-bottom: 10px;
  padding: 12px 15px;
  border-radius: 8px;
  display: flex;
  align-items: center;
  gap: 10px;
}
.exam-list input[type="number"] {
  width: 60px;
  margin-left: 10px;
}
.exam-list button {
  margin-top: 0;
  margin-left: 10px;
  background-color: #3498db;
}
.delete-btn {
  background-color: #e74c3c;
  color: white;
}
.exam-list-empty {
  margin-top: 20px;
  color: #888;
  font-style: italic;
}
.message {
  margin-top: 15px;
  color: green;
}
</style>
