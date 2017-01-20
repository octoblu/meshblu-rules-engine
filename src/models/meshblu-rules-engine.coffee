_ = require 'lodash'
{Engine} = require 'json-rules-engine'


class MeshbluRulesEngine
  constructor: (@config)->
    @engine = new Engine
    _.each @config.rules, (rule) => @engine.addRule rule

  run: (device, callback) =>
    @engine
      .run {device}
      .then (events) =>
        return callback null, events unless _.isEmpty events
        return callback null, @config.noevents || []

      .catch (error) => callback error

    return null

module.exports = MeshbluRulesEngine
