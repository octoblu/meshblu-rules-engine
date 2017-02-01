_ = require 'lodash'
{Engine} = require 'json-rules-engine'
christacheio = require 'christacheio'
RefResolver = require 'meshblu-json-schema-resolver'
class MeshbluRulesEngine
  constructor: ({@rulesConfig, @meshbluConfig})->
    @engine = new Engine _.concat(_.values(@rulesConfig.if), _.values(@rulesConfig.rules))
    @_addOperators @engine

  run: ({data={}, metadata={}, device={}}, callback) =>
    resolver = new RefResolver {@meshbluConfig}
    resolver.resolve {data, metadata, device}, (error, resolved) =>
      return callback error if error?
      @engine
        .run resolved
        .then (events) =>
          return callback null, @_templateEvents {resolved, events} unless _.isEmpty events
          @_runElse {resolved}, callback
        .catch (error) => callback error
    return null

  _runElse: ({resolved}, callback) =>
    elseEngine = new Engine _.values(@rulesConfig.else)
    @_addOperators elseEngine
    elseEngine
      .run resolved
      .then (events) =>
        events = @rulesConfig.noevents || [] if _.isEmpty events
        return callback null, @_templateEvents {resolved, events}
      .catch (error) => callback error

  _templateEvents: ({resolved, events}) =>
    _.map events, (event) => christacheio event, resolved

  _addOperators: (engine) =>
    engine.addOperator 'exists', @_existentialOperator

  _existentialOperator: (factValue, jsonValue) =>
    return (factValue != undefined) == jsonValue

module.exports = MeshbluRulesEngine
