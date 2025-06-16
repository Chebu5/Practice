const { DataTypes } = require('sequelize');
const sequelize = require('../db');

const Graduate = sequelize.define('Graduate', {
  graduate_id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
  },
  full_name: {
    type: DataTypes.STRING,
    allowNull: false,
  },
  specialty: {
    type: DataTypes.STRING,
  },
  university_id: {
    type: DataTypes.INTEGER,
    allowNull: false,
    references: {
      model: 'universities',
      key: 'university_id'
    }
  },
  contact_email: {
    type: DataTypes.STRING,
  },
  contact_phone: {
    type: DataTypes.STRING,
  },
}, {
  tableName: 'graduates',
  timestamps: false,
  underscored: true,
});


module.exports = Graduate;
