const express = require('express');
const cors = require('cors');

const app = express();
const PORT = process.env.PORT || 3001;

let vacancies = [];

app.use(cors());
app.use(express.json());

app.get('/', (req, res) => {
  res.send('Career Navigator API is running');
});

app.post('/api/vacancies', (req, res) => {
  const vacancy = req.body;
  vacancy.id = vacancies.length + 1; // Исправлено: +1 чтобы id начинался с 1
  vacancies.push(vacancy);
  res.status(201).json(vacancy);
});

app.get('/api/vacancies', (req, res) => {
  res.send('Career Navigator API is running');
});

// Обработка 404
app.use((req, res) => {
  res.status(404).json({ error: 'Not found' });
});

app.listen(PORT, () => {
  console.log(`Server started on port ${PORT}`);
});