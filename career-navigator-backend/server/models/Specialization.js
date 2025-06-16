const { DataTypes } = require('sequelize');
const sequelize = require('../db'); // путь к вашему экземпляру Sequelize

const Specialization = sequelize.define('Specialization', {
  specialization_id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  name: {
    type: DataTypes.STRING,
    allowNull: false,
    unique: true
  }
}, {
  tableName: 'specializations',
  timestamps: false,
  underscored: true
});

module.exports = Specialization;
