// models/universitySpecializationExam.js
const { DataTypes } = require('sequelize');
const sequelize = require('../db');

const UniversitySpecialization = sequelize.define('UniversitySpecialization', {
  university_id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    allowNull: false,
  },
  specialization_id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    allowNull: false,
  },
  exam_name: {
    type: DataTypes.STRING,
    primaryKey: true,
    allowNull: false,
  },
  pass_mark: {
    type: DataTypes.INTEGER,
    allowNull: false,
  }
}, {
  tableName: 'university_specializations',
  timestamps: false,
  underscored: true
});

module.exports = UniversitySpecialization;
