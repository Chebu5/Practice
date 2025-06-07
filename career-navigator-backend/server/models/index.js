const Employer = require('./Employer');
const Vacancy = require('./Vacancy');
const University = require('./University');
const Applicant = require('./Applicant');
const EmployerUniversityMessage = require('./EmployerUniversityMessage');
const Graduate = require('./Graduate');
const EducationRequirement = require('./EducationRequirement');
const Skill = require('./Skill');
const VacancySkill = require('./VacancySkill');

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
  VacancySkill
};

module.exports = models;
