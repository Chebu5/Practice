const { DataTypes } = require('sequelize');
const db = require('../db');

const Applicant = db.define('Applicant', {
  applicant_id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
  },
  full_name: {
    type: DataTypes.STRING(255),
    allowNull: false,
  },
  email: {
    type: DataTypes.STRING(255),
    unique: true,
    allowNull: false,
  },
  password_hash: {
    type: DataTypes.STRING(255),
    allowNull: false,
  },
  phone: {
    type: DataTypes.STRING(20),
  },
  university_id: {
    type: DataTypes.INTEGER,
    allowNull: true,
    references: {
      model: 'universities',
      key: 'university_id'
    }
  },
  specialization_id: {
    type: DataTypes.INTEGER,
    allowNull: true,
    references: {
      model: 'specializations',
      key: 'specialization_id'
    }
  },
  created_at: {
    type: DataTypes.DATE,
    defaultValue: DataTypes.NOW,
  },
}, {
  tableName: 'applicants',
  timestamps: false,
});


module.exports = Applicant;
