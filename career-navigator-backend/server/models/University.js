const { DataTypes } = require('sequelize');
const db = require('../db');

const University = db.define('University', {
  university_id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
  },
  name: {
    type: DataTypes.STRING(255),
    allowNull: false,
  },
  contact_email: {
    type: DataTypes.STRING(255),
  },
  password_hash: {
    type: DataTypes.STRING(255),
    allowNull: false, // или true, если поле необязательное
  },
}, {
  tableName: 'universities',
  timestamps: false,
});

module.exports = University;
