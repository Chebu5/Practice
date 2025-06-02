const Employer = require('./Employer');
const Vacancy = require('./Vacancy');
const University = require('./university');
const Applicant = require('./applicant');

Vacancy.belongsTo(Employer, { foreignKey: 'employer_id', as: 'employer' });
Employer.hasMany(Vacancy, { foreignKey: 'employer_id' });

module.exports = {
  Employer,
  Vacancy,
  University,
  Applicant,
};
