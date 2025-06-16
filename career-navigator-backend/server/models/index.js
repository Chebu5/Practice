const Employer = require('./Employer');
const Vacancy = require('./Vacancy');
const University = require('./University');
const Applicant = require('./Applicant');
const EmployerUniversityMessage = require('./EmployerUniversityMessage');
const Graduate = require('./Graduate');
const EducationRequirement = require('./EducationRequirement');
const Skill = require('./Skill');
const VacancySkill = require('./VacancySkill');
const Specialization = require('./Specialization'); // импорт модели специальностей
const UniversitySpecialization = require('./universitySpecialization')
// Связь многие-ко-многим между университетами и специальностями
Graduate.belongsTo(University, { foreignKey: 'university_id', as: 'university' });
University.belongsToMany(Specialization, {
  through: 'university_specializations',
  foreignKey: 'university_id',
  otherKey: 'specialization_id',
  as: 'specializations'
});

Specialization.belongsToMany(University, {
  through: 'university_specializations',
  foreignKey: 'specialization_id',
  otherKey: 'university_id',
  as: 'universities'
});
Applicant.belongsTo(University, { foreignKey: 'university_id', as: 'university' });
Applicant.belongsTo(Specialization, { foreignKey: 'specialization_id', as: 'specialization' });

// Настройка ассоциаций
Vacancy.belongsTo(Employer, { foreignKey: 'employer_id', as: 'employer' });
Employer.hasMany(Vacancy, { foreignKey: 'employer_id' });

Vacancy.hasMany(EducationRequirement, { foreignKey: 'vacancy_id', as: 'educationRequirements' });
EducationRequirement.belongsTo(Vacancy, { foreignKey: 'vacancy_id', as: 'vacancy' });

Vacancy.belongsToMany(Skill, { through: VacancySkill, foreignKey: 'vacancy_id', as: 'skills' });
Skill.belongsToMany(Vacancy, { through: VacancySkill, foreignKey: 'skill_id', as: 'vacancies' });

VacancySkill.belongsTo(Vacancy, { foreignKey: 'vacancy_id' });
VacancySkill.belongsTo(Skill, { foreignKey: 'skill_id' });

const models = {
  Employer,
  Vacancy,
  University,
  Applicant,
  EmployerUniversityMessage,
  Graduate,
  EducationRequirement,
  Skill,
  VacancySkill,
  Specialization,
  UniversitySpecialization
};

module.exports = models;
