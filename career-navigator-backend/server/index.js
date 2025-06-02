// index.js (основной серверный файл)
require('dotenv').config();
const express = require('express');
const cors = require('cors');
const sequelize = require('./db');
const { Employer, Vacancy } = require('./models');

const app = express();
const PORT = 3001;

app.use(cors());
app.use(express.json());

// Проверка подключения к БД
sequelize.authenticate()
  .then(() => console.log('Database connected...'))
  .catch(err => console.error('Connection error:', err));

// Синхронизация моделей с БД
sequelize.sync()
  .then(() => console.log('Models synchronized with database'))
  .catch(err => console.error('Sync error:', err));

// Маршруты
app.get('/', (req, res) => {
  res.send('Career Navigator API is running');
});

// Получение всех вакансий с информацией о работодателе
app.get('/api/vacancies', async (req, res) => {
  try {
    const vacancies = await Vacancy.findAll({
      include: [
        {
          model: Employer,
          as: 'employer',
          attributes: ['company_name', 'contact_phone']
        }
      ],
      order: [['created_at', 'DESC']]
    });
    res.json(vacancies);
  } catch (error) {
    console.error('Error fetching vacancies:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});
// Добавление вакансии
app.post('/api/vacancies', async (req, res) => {
  try {
    const { title, description, min_salary, max_salary, employer_id } = req.body;
    const vacancy = await Vacancy.create({ 
      title, 
      description,
      min_salary,
      max_salary,
      employer_id
    });
    res.status(201).json(vacancy);
  } catch (error) {
    console.error('Error creating vacancy:', error);
    res.status(500).json({ error: error.message });
  }
});

// Обработка ошибок
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).send('Something broke!');
});

// Обработка 404
app.use((req, res) => {
  res.status(404).json({ error: 'Not found' });
});

// Запуск сервера
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});