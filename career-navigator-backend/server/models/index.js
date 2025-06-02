// models/index.js
const { Sequelize } = require('sequelize');
const db = require('../db');

const Employer = require('./Employer');
const Vacancy = require('./Vacancy');

Vacancy.belongsTo(Employer, { foreignKey: 'employer_id', as: 'employer' });
Employer.hasMany(Vacancy, { foreignKey: 'employer_id' });

module.exports = {
  Employer,
  Vacancy,
};

