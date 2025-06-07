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
  specialty: {
    type: DataTypes.STRING,
    allowNull: true
  },
  requirements: {
    type: DataTypes.TEXT,
    allowNull: true
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

Vacancy.associate = (models) => {
  Vacancy.hasMany(models.EducationRequirement, {
    foreignKey: 'vacancy_id',
    as: 'educationRequirements'
  });

  Vacancy.belongsToMany(models.Skill, {
    through: models.VacancySkill,
    foreignKey: 'vacancy_id',
    as: 'skills'
  });
};

module.exports = Vacancy;
