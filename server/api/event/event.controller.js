'use strict';

var _ = require('lodash');
var events = require('./logs.json');

// Get list of events
exports.index = function(req, res) {
  res.json(events);
};