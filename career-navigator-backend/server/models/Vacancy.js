const { DataTypes } = require('sequelize');
const sequelize = require('../db');

const Vacancy = sequelize.define('Vacancy', {
  vacancy_id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  title: {
    type: DataTypes.STRING,
    allowNull: false
  },
  description: {
    type: DataTypes.TEXT,
    allowNull: false
  },
  min_salary: {
    type: DataTypes.INTEGER
  },
  max_salary: {
    type: DataTypes.INTEGER
  },
  employer_id: {
    type: DataTypes.INTEGER,
    references: {
      model: 'employers',
      key: 'employer_id'
    }
  },
  created_at: {
    type: DataTypes.DATE,
    defaultValue: DataTypes.NOW
  }
}, {
  tableName: 'vacancies',
  timestamps: false,
  underscored: true
});

module.exports = Vacancy;
