'use strict';

var _ = require('lodash');
var users = require('./users.json');

// Get list of users
exports.index = function(req, res) {
  res.json(users);
};