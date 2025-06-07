const { DataTypes } = require('sequelize');
const db = require('../db');
const Vacancy = require('./Vacancy');
const Skill = require('./Skill');

const VacancySkill = db.define('VacancySkill', {
  vacancy_id: { 
    type: DataTypes.INTEGER, 
    allowNull: false, 
    primaryKey: true,
    references: {
      model: 'vacancies',
      key: 'vacancy_id'
    },
    onDelete: 'CASCADE',
    onUpdate: 'CASCADE'
  },
  skill_id: { 
    type: DataTypes.INTEGER, 
    allowNull: false, 
    primaryKey: true,
    references: {
      model: 'skills',
      key: 'skill_id'
    },
    onDelete: 'CASCADE',
    onUpdate: 'CASCADE'
  },
}, {
  tableName: 'vacancy_skills',
  timestamps: false,
  underscored: true, // если в базе используется snake_case
});

// Ассоциации для связи многие-ко-многим
// Vacancy.belongsToMany(Skill, { 
//   through: VacancySkill, 
//   foreignKey: 'vacancy_id', 
//   otherKey: 'skill_id',
//   as: 'skills'
// });

// Skill.belongsToMany(Vacancy, { 
//   through: VacancySkill, 
//   foreignKey: 'skill_id', 
//   otherKey: 'vacancy_id',
//   as: 'vacancies'
// });

// // При необходимости можно добавить belongsTo для VacancySkill
// VacancySkill.belongsTo(Vacancy, { foreignKey: 'vacancy_id' });
// VacancySkill.belongsTo(Skill, { foreignKey: 'skill_id' });

module.exports = VacancySkill;
