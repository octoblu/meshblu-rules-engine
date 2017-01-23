_ = require 'lodash'
{Engine} = require 'json-rules-engine'
christacheio = require 'christacheio'

class MeshbluRulesEngine
  constructor: (@config)->
    @engine = new Engine
    @engine.addOperator 'exists', @_existentialOperator
    _.each @config.rules, (rule) => @engine.addRule rule

  run: (device, callback) =>
    @engine
      .run {device}
      .then (events) =>
        events = @config.noevents || [] if _.isEmpty events
        return callback null, @_templateEvents {device, events}
      .catch (error) => callback error
    return null

  _templateEvents: ({device, events}) =>
    _.map events, (event) => christacheio event, device

  _existentialOperator: (factValue, jsonValue) =>
    return (factValue != undefined) == jsonValue

module.exports = MeshbluRulesEngine
