const { DataTypes } = require('sequelize');
const db = require('../db');
const Vacancy = require('./Vacancy');

const EducationRequirement = db.define('EducationRequirement', {
  requirement_id: { 
    type: DataTypes.INTEGER, 
    primaryKey: true, 
    autoIncrement: true 
  },
  vacancy_id: { 
    type: DataTypes.INTEGER, 
    allowNull: false,
    references: {
      model: 'vacancies',  // название таблицы в БД
      key: 'vacancy_id'
    },
    onDelete: 'CASCADE',
    onUpdate: 'CASCADE'
  },
  degree_level: { 
    type: DataTypes.STRING, 
    allowNull: false 
  },
}, {
  tableName: 'education_requirements',
  timestamps: false,
  underscored: true,
});
module.exports = EducationRequirement;
