require('dotenv').config();
const express = require('express');
const cors = require('cors');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const sequelize = require('./db');
const {
  Employer,
  Vacancy,
  University,
  Applicant,
  EducationRequirement,
  VacancySkill,
  Skill,
  Graduate,
  EmployerUniversityMessage,
  Specialization,
  UniversitySpecialization
} = require('./models');

const app = express();
const PORT = 3001;
const JWT_SECRET = process.env.JWT_SECRET || 'your_secret_key';

app.use(cors());
app.use(express.json());

sequelize.authenticate()
  .then(() => console.log('Database connected...'))
  .catch(err => console.error('Connection error:', err));

sequelize.sync()
  .then(() => console.log('Models synchronized with database'))
  .catch(err => console.error('Sync error:', err));

app.get('/', (req, res) => {
  res.send('Career Navigator API is running');
});

// Middleware для проверки JWT-токена
const authenticateToken = (req, res, next) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) return res.sendStatus(401);

  jwt.verify(token, JWT_SECRET, (err, user) => {
    if (err) return res.sendStatus(403);
    req.user = user;
    next();
  });
};
////////
app.get('/api/university/exams', authenticateToken, async (req, res) => {
  try {
    if (!req.user.university_id) return res.status(403).json({ error: 'Доступ запрещён' });
    const { specialization_id } = req.query;
    const where = { university_id: req.user.university_id };
    if (specialization_id) where.specialization_id = specialization_id;
    const exams = await UniversitySpecialization.findAll({ where });
    res.json(exams);
  } catch (error) {
    console.error('Ошибка получения экзаменов:', error);
    res.status(500).json({ error: 'Внутренняя ошибка сервера' });
  }
});
// Удаление экзамена для специальности (university_specializations)
app.delete('/api/university/exams', authenticateToken, async (req, res) => {
  try {
    if (!req.user.university_id) return res.status(403).json({ error: 'Доступ запрещён' });
    const { specialization_id, exam_name } = req.query;
    if (!specialization_id || !exam_name) {
      return res.status(400).json({ error: 'Не хватает параметров' });
    }
    const deleted = await UniversitySpecialization.destroy({
      where: {
        university_id: req.user.university_id,
        specialization_id,
        exam_name
      }
    });
    if (deleted) {
      res.json({ message: 'Экзамен удалён' });
    } else {
      res.status(404).json({ error: 'Экзамен не найден' });
    }
  } catch (error) {
    console.error('Ошибка удаления экзамена:', error);
    res.status(500).json({ error: 'Внутренняя ошибка сервера' });
  }
});

////////
app.post('/api/university/exams', authenticateToken, async (req, res) => {
  try {
    // Проверяем, что пользователь — вуз
    if (!req.user.university_id) {
      return res.status(403).json({ error: 'Доступ запрещён' });
    }
    const { specialization_id, exam_name, pass_mark } = req.body;
    if (!specialization_id || !exam_name || pass_mark == null) {
      return res.status(400).json({ error: 'Заполните все поля' });
    }

    // Добавляем или обновляем запись
    const [record, created] = await UniversitySpecialization.upsert({
      university_id: req.user.university_id,
      specialization_id,
      exam_name,
      pass_mark
    });

    res.status(201).json({ message: created ? 'Экзамен добавлен' : 'Экзамен обновлён', record });
  } catch (error) {
    console.error('Ошибка добавления экзамена:', error);
    res.status(500).json({ error: 'Внутренняя ошибка сервера' });
  }
});
////////
app.put('/api/university/exams', authenticateToken, async (req, res) => {
  try {
    if (!req.user.university_id) return res.status(403).json({ error: 'Доступ запрещён' });
    const { specialization_id, exam_name, pass_mark } = req.body;
    if (!specialization_id || !exam_name || pass_mark == null) {
      return res.status(400).json({ error: 'Заполните все поля' });
    }
    const [updated] = await UniversitySpecialization.update(
      { pass_mark },
      {
        where: {
          university_id: req.user.university_id,
          specialization_id,
          exam_name
        }
      }
    );
    if (updated) {
      res.json({ message: 'Экзамен обновлён' });
    } else {
      res.status(404).json({ error: 'Экзамен не найден' });
    }
  } catch (error) {
    console.error('Ошибка обновления экзамена:', error);
    res.status(500).json({ error: 'Внутренняя ошибка сервера' });
  }
});

////////
app.post('/api/graduates', authenticateToken, async (req, res) => {
  try {
    // Для вуза: university_id берём из токена
    if (!req.user.university_id) {
      return res.status(403).json({ error: 'Доступ запрещён' });
    }
    const { full_name, specialty, contact_email, contact_phone } = req.body;
    if (!full_name || !contact_email || !contact_phone) {
      return res.status(400).json({ error: 'Заполните все поля' });
    }
    const graduate = await Graduate.create({
      full_name,
      specialty,
      university_id: req.user.university_id,
      contact_email,
      contact_phone
    });
    res.status(201).json({ message: 'Выпускник добавлен', graduate });
  } catch (error) {
    console.error('Ошибка добавления выпускника:', error);
    res.status(500).json({ error: 'Внутренняя ошибка сервера' });
  }
});
////////
app.get('/api/specializations', async (req, res) => {
  try {
    const specs = await Specialization.findAll({
      attributes: ['specialization_id', 'name'],
      order: [['name', 'ASC']]
    });
    res.json(specs);
  } catch (error) {
    console.error('Ошибка получения специальностей:', error);
    res.status(500).json({ error: 'Внутренняя ошибка сервера' });
  }
});

/////////
app.get('/api/universities', async (req, res) => {
  try {
    const universities = await University.findAll({
      attributes: ['university_id', 'name'],
      order: [['name', 'ASC']]
    });
    res.json(universities);
  } catch (err) {
    console.error('Ошибка получения вузов:', err);
    res.status(500).json({ error: 'Ошибка сервера' });
  }
});

// Получение профиля абитуриента
// Получение профиля абитуриента
app.get('/api/applicant/profile', authenticateToken, async (req, res) => {
  try {
    // Проверяем, что в токене есть applicant_id
    if (!req.user.applicant_id) {
      return res.status(403).json({ error: 'Доступ запрещён' });
    }

    // Вот сюда вставьте ваш код:
    const applicant = await Applicant.findByPk(req.user.applicant_id, {
      attributes: ['applicant_id', 'full_name', 'email', 'phone', 'university_id', 'specialization_id'],
      include: [
        {
          model: University,
          as: 'university',
          attributes: ['university_id', 'name']
        },
        {
          model: Specialization,
          as: 'specialization',
          attributes: ['specialization_id', 'name']
        }
      ]
    });

    if (!applicant) {
      return res.status(404).json({ error: 'Абитуриент не найден' });
    }

    res.json(applicant);
  } catch (error) {
    console.error('Ошибка получения профиля абитуриента:', error);
    res.status(500).json({ error: 'Внутренняя ошибка сервера' });
  }
});

////////////////
app.get('/api/universities/:universityId/specializations', async (req, res) => {
  const universityId = parseInt(req.params.universityId, 10);
  if (isNaN(universityId)) {
    return res.status(400).json({ error: 'Неверный ID университета' });
  }
  try {
    // Получаем все уникальные специальности для вуза
    const specs = await UniversitySpecialization.findAll({
      where: { university_id: universityId },
      attributes: ['specialization_id'],
      group: ['specialization_id']
    });

    const result = [];
    for (const { specialization_id } of specs) {
      const spec = await Specialization.findByPk(specialization_id, { attributes: ['specialization_id', 'name'] });
      const exams = await UniversitySpecialization.findAll({
        where: { university_id: universityId, specialization_id },
        attributes: ['exam_name', 'pass_mark']
      });
      result.push({
        specialization_id,
        name: spec ? spec.name : '',
        exams: exams.map(e => ({
          exam_name: e.exam_name,
          pass_mark: e.pass_mark
        }))
      });
    }
    res.json(result);
  } catch (error) {
    console.error('Ошибка получения специальностей и экзаменов для университета:', error);
    res.status(500).json({ error: 'Внутренняя ошибка сервера' });
  }
});

// Обновление профиля абитуриента
app.put('/api/applicant/profile', authenticateToken, async (req, res) => {
  try {
    if (!req.user.applicant_id) {
      return res.status(403).json({ error: 'Доступ запрещён' });
    }

    const { full_name, phone, university_id, specialization_id } = req.body;

    const applicant = await Applicant.findByPk(req.user.applicant_id);
    if (!applicant) {
      return res.status(404).json({ error: 'Абитуриент не найден' });
    }

    if (full_name !== undefined) applicant.full_name = full_name;
    if (phone !== undefined) applicant.phone = phone;
    if (university_id !== undefined) applicant.university_id = university_id;
    if (specialization_id !== undefined) applicant.specialization_id = specialization_id;

    await applicant.save();

    res.json({ message: 'Профиль абитуриента обновлён', applicant });
  } catch (error) {
    console.error('Ошибка обновления профиля абитуриента:', error);
    res.status(500).json({ error: 'Внутренняя ошибка сервера' });
  }
});

//////////////////
app.get('/api/applicant/vacancies', authenticateToken, async (req, res) => {
  try {
    const vacancies = await Vacancy.findAll({
  include: [
    {
      model: Employer,
      as: 'employer',
      attributes: ['company_name']  // или другие нужные поля
    },
    {
      model: EducationRequirement,
      as: 'educationRequirements',
      attributes: ['degree_level'] // без специализации
    },
    {
      model: Skill,
      as: 'skills',
      attributes: ['name'], // или нужные поля
      through: { attributes: [] } // чтобы не возвращать данные из промежуточной таблицы
    }
  ],
  order: [['created_at', 'DESC']]
});
    res.json(vacancies)
  } catch (error) {
    console.error('Ошибка получения вакансий:', error)
    res.status(500).json({ error: 'Внутренняя ошибка сервера' })
  }
})
/////////////
// Универсальный маршрут регистрации
app.post('/api/register', async (req, res) => {
  try {
    const { role, email, password, company_name, contact_phone, full_name, phone, university_name } = req.body;

    if (!role || !email) {
      return res.status(400).json({ error: 'Отсутствуют обязательные поля' });
    }

    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
      return res.status(400).json({ error: 'Некорректный email' });
    }

    if ((role === 'employer' || role === 'applicant' || role === 'university') && !password) {
      return res.status(400).json({ error: 'Пароль обязателен' });
    }

    const password_hash = password ? await bcrypt.hash(password, 10) : null;

    if (role === 'employer') {
      if (!company_name) return res.status(400).json({ error: 'Введите название компании' });

      const exists = await Employer.findOne({ where: { email } });
      if (exists) return res.status(400).json({ error: 'Работодатель с таким email уже существует' });

      const newEmployer = await Employer.create({ company_name, email, password_hash, contact_phone });
      return res.status(201).json({ message: 'Работодатель зарегистрирован', employer_id: newEmployer.employer_id });

    } else if (role === 'applicant') {
      if (!full_name) return res.status(400).json({ error: 'Введите полное имя' });

      const exists = await Applicant.findOne({ where: { email } });
      if (exists) return res.status(400).json({ error: 'Абитуриент с таким email уже существует' });

      const newApplicant = await Applicant.create({ full_name, email, password_hash, phone });
      return res.status(201).json({ message: 'Абитуриент зарегистрирован', applicant_id: newApplicant.applicant_id });

    } else if (role === 'university') {
      if (!university_name) return res.status(400).json({ error: 'Введите название вуза' });

      const exists = await University.findOne({ where: { contact_email: email } });
      if (exists) return res.status(400).json({ error: 'Вуз с таким email уже существует' });

      const newUniversity = await University.create({ name: university_name, contact_email: email, password_hash });
      return res.status(201).json({ message: 'Вуз зарегистрирован', university_id: newUniversity.university_id });

    } else {
      return res.status(400).json({ error: 'Неизвестная роль' });
    }
  } catch (error) {
    console.error('Ошибка регистрации:', error);
    res.status(500).json({ error: 'Внутренняя ошибка сервера' });
  }
});

// Универсальный маршрут входа
app.post('/api/login', async (req, res) => {
  try {
    const { role, email, password } = req.body;

    if (!role || !email || !password) {
      return res.status(400).json({ error: 'Отсутствуют обязательные поля' });
    }

    let user = null;

    if (role === 'employer') {
      user = await Employer.findOne({ where: { email } });
    } else if (role === 'applicant') {
      user = await Applicant.findOne({ where: { email } });
    } else if (role === 'university') {
      user = await University.findOne({ where: { contact_email: email } });
    } else {
      return res.status(400).json({ error: 'Неизвестная роль' });
    }

    if (!user) {
      return res.status(401).json({ error: 'Неверный email или пароль' });
    }

    const passwordMatch = await bcrypt.compare(password, user.password_hash);
    if (!passwordMatch) {
      return res.status(401).json({ error: 'Неверный email или пароль' });
    }

    const payload = { role };
    if (role === 'employer') payload.employer_id = user.employer_id;
    if (role === 'applicant') payload.applicant_id = user.applicant_id;
    if (role === 'university') payload.university_id = user.university_id;

    const token = jwt.sign(payload, JWT_SECRET, { expiresIn: '1h' });

    res.json({ message: 'Успешный вход', token, role });
  } catch (error) {
    console.error('Ошибка входа:', error);
    res.status(500).json({ error: 'Внутренняя ошибка сервера' });
  }
});

// Получение всех вакансий с информацией о работодателе
app.get('/api/vacancies', async (req, res) => {
  try {
    const vacancies = await Vacancy.findAll({
      include: [{
        model: Employer,
        as: 'employer',
        attributes: ['company_name', 'contact_phone']
      }],
      order: [['created_at', 'DESC']]
    });
    res.json(vacancies);
  } catch (error) {
    console.error('Error fetching vacancies:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Добавление вакансии с требованиями и навыками (защищено JWT)
app.post('/api/employer/vacancies', authenticateToken, async (req, res) => {
  try {
    const { title, description, min_salary, max_salary, specialty, educationRequirements, skillIds } = req.body;

    const vacancy = await Vacancy.create({
      title,
      description,
      min_salary,
      max_salary,
      specialty,  // сохраняем уровень образования в поле specialty вакансии
      employer_id: req.user.employer_id,
    });

    if (Array.isArray(educationRequirements)) {
      for (const reqEd of educationRequirements) {
        await EducationRequirement.create({
          vacancy_id: vacancy.vacancy_id,
          specialization_id: reqEd.specialization_id || null, // если есть, иначе null
          degree_level: reqEd.degree_level,
        });
      }
    }

    if (Array.isArray(skillIds)) {
      for (const skillId of skillIds) {
        await VacancySkill.create({
          vacancy_id: vacancy.vacancy_id,
          skill_id: skillId,
        });
      }
    }

    res.status(201).json(vacancy);
  } catch (error) {
    console.error('Error creating vacancy:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});
/////////
app.get('/api/employers', async (req, res) => {
  try {
    const employers = await Employer.findAll({
      attributes: ['employer_id', 'company_name'],
      order: [['company_name', 'ASC']]
    });
    res.json(employers);
  } catch (err) {
    res.status(500).json({ error: 'Ошибка сервера' });
  }
});
//////////
// Модель EmployerUniversityMessage уже импортирована
app.post('/api/university/messages', authenticateToken, async (req, res) => {
  try {
    // Проверяем, что пользователь — вуз
    if (!req.user.university_id) {
      return res.status(403).json({ error: 'Доступ запрещён' });
    }
    const { employer_id, message } = req.body;
    if (!employer_id || !message) {
      return res.status(400).json({ error: 'Не указан работодатель или текст сообщения' });
    }
    const newMessage = await EmployerUniversityMessage.create({
      employer_id,
      university_id: req.user.university_id,
      message,
      status: 'sent',
      created_at: new Date(),
    });
    res.status(201).json(newMessage);
  } catch (error) {
    console.error('Ошибка отправки сообщения вузом работодателю:', error);
    res.status(500).json({ error: 'Внутренняя ошибка сервера' });
  }
});
/////////////
app.get('/api/university/messages', authenticateToken, async (req, res) => {
  try {
    if (!req.user.university_id) {
      return res.status(403).json({ error: 'Доступ запрещён' });
    }
    const messages = await EmployerUniversityMessage.findAll({
      where: { university_id: req.user.university_id },
      order: [['created_at', 'DESC']]
    });
    res.json(messages);
  } catch (error) {
    console.error('Ошибка получения истории сообщений для вуза:', error);
    res.status(500).json({ error: 'Внутренняя ошибка сервера' });
  }
});

// Получение вакансий работодателя с требованиями и навыками
app.get('/api/employer/vacancies', authenticateToken, async (req, res) => {
  try {
    const vacancies = await Vacancy.findAll({
      where: { employer_id: req.user.employer_id },
      include: [
        {
          model: EducationRequirement,
          as: 'educationRequirements'
        },
        {
          model: Skill,
          as: 'skills',
          through: { attributes: [] }
        }
      ]
    });
    res.json(vacancies);
  } catch (error) {
    console.error('Error fetching employer vacancies:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Личный кабинет работодателя - получение профиля
app.get('/api/employer/profile', authenticateToken, async (req, res) => {
  try {
    const employer = await Employer.findByPk(req.user.employer_id, {
      attributes: ['employer_id', 'company_name', 'email', 'contact_phone']
    });
    if (!employer) return res.status(404).json({ error: 'Работодатель не найден' });
    res.json(employer);
  } catch (error) {
    console.error('Error fetching employer profile:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Личный кабинет работодателя - обновление профиля
app.put('/api/employer/profile', authenticateToken, async (req, res) => {
  try {
    const { company_name, contact_phone } = req.body;
    const employer = await Employer.findByPk(req.user.employer_id);
    if (!employer) return res.status(404).json({ error: 'Работодатель не найден' });

    if (company_name !== undefined) employer.company_name = company_name;
    if (contact_phone !== undefined) employer.contact_phone = contact_phone;
    await employer.save();

    res.json({ message: 'Профиль обновлен', employer });
  } catch (error) {
    console.error('Error updating employer profile:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Просмотр профилей выпускников с фильтрацией
app.get('/api/graduates', authenticateToken, async (req, res) => {
  try {
    const { university_id } = req.query;
    const where = {};
    if (university_id) where.university_id = university_id;

    const graduates = await Graduate.findAll({
      where,
      include: [
        {
          model: University,
          as: 'university',
          attributes: ['university_id', 'name']
        }
      ]
    });
    res.json(graduates);
  } catch (error) {
    console.error('Error fetching graduates:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});


// Удаление вакансии работодателем
app.delete('/api/employer/vacancies/:id', authenticateToken, async (req, res) => {
  try {
    const vacancyId = req.params.id;

    // Проверяем, принадлежит ли вакансия текущему работодателю
    const vacancy = await Vacancy.findOne({
      where: {
        vacancy_id: vacancyId,
        employer_id: req.user.employer_id
      }
    });

    if (!vacancy) {
      return res.status(404).json({ error: 'Вакансия не найдена или не принадлежит вам' });
    }

    // Удаляем связанные требования к образованию и навыки (если настроены каскадно, можно не делать явно)
    await EducationRequirement.destroy({ where: { vacancy_id: vacancyId } });
    await VacancySkill.destroy({ where: { vacancy_id: vacancyId } });

    // Удаляем саму вакансию
    await vacancy.destroy();

    res.json({ message: 'Вакансия удалена' });
  } catch (error) {
    console.error('Error deleting vacancy:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

// Отправка сообщений вузам
app.post('/api/employer/messages', authenticateToken, async (req, res) => {
  try {
    const { university_id, message } = req.body;
    const newMessage = await EmployerUniversityMessage.create({
      employer_id: req.user.employer_id,
      university_id,
      message,
      status: 'sent',
      created_at: new Date(),
    });
    res.status(201).json(newMessage);
  } catch (error) {
    console.error('Error sending message:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});
/////////
// Получение профиля вуза
app.get('/api/university/profile', authenticateToken, async (req, res) => {
  try {
    if (!req.user.university_id) {
      return res.status(403).json({ error: 'Доступ запрещён' });
    }
    const university = await University.findByPk(req.user.university_id, {
      attributes: ['university_id', 'name', 'contact_email']
    });
    if (!university) {
      return res.status(404).json({ error: 'Вуз не найден' });
    }
    res.json(university);
  } catch (error) {
    console.error('Ошибка получения профиля вуза:', error);
    res.status(500).json({ error: 'Внутренняя ошибка сервера' });
  }
});

// Получение истории сообщений работодателя
app.get('/api/employer/messages', authenticateToken, async (req, res) => {
  try {
    const messages = await EmployerUniversityMessage.findAll({
      where: { employer_id: req.user.employer_id },
      order: [['created_at', 'DESC']]
    });
    res.json(messages);
  } catch (error) {
    console.error('Error fetching messages:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});



// Обработчики ошибок
app.use((err, req, res, next) => {
  console.error(err.stack);
  res.status(500).send('Something broke!');
});

app.use((req, res) => {
  res.status(404).json({ error: 'Not found' });
});

app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
