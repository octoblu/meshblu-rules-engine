_ = require 'lodash'
{Engine} = require 'json-rules-engine'


class MeshbluRulesEngine
  constructor: ->
    @engine = new Engine

  addRule: (rule) =>
    @engine.addRule rule

  addRules: (rules) =>
    _.each rules, @addRule

  run: (device, callback) =>
    @engine
      .run {device}
      .then (events) => callback null, events
      .catch (error) => callback error

    return null

module.exports = MeshbluRulesEngine
