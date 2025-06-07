// models/Skill.js
const { DataTypes } = require('sequelize');
const db = require('../db');

const Skill = db.define('Skill', {
  skill_id: { type: DataTypes.INTEGER, primaryKey: true, autoIncrement: true },
  name: { type: DataTypes.STRING, unique: true, allowNull: false },
}, {
  tableName: 'skills',
  timestamps: false,
});

module.exports = Skill;
