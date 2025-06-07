const { DataTypes } = require('sequelize');
const sequelize = require('../db'); // ваш экземпляр Sequelize

const EmployerUniversityMessage = sequelize.define('EmployerUniversityMessage', {
  message_id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
  },
  employer_id: {
    type: DataTypes.INTEGER,
    allowNull: false,
    references: {
      model: 'employers',
      key: 'employer_id',
    },
    onDelete: 'CASCADE',
  },
  university_id: {
    type: DataTypes.INTEGER,
    allowNull: false,
    references: {
      model: 'universities',
      key: 'university_id',
    },
    onDelete: 'CASCADE',
  },
  message: {
    type: DataTypes.TEXT,
    allowNull: false,
  },
  status: {
    type: DataTypes.STRING,
    defaultValue: 'sent',
  },
  created_at: {
    type: DataTypes.DATE,
    defaultValue: DataTypes.NOW,
  },
}, {
  tableName: 'employer_university_messages',
  timestamps: false,
  underscored: true,
});

module.exports = EmployerUniversityMessage;
