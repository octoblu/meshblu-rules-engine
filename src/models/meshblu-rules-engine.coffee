_ = require 'lodash'
{Engine} = require 'json-rules-engine'
christacheio = require 'christacheio'
RefResolver = require 'meshblu-json-schema-resolver'
class MeshbluRulesEngine
  constructor: ({@rulesConfig, @meshbluConfig})->

  run: ({data={}, metadata={}, device={}}, callback) =>
    resolver = new RefResolver {@meshbluConfig}
    resolver.resolve { data, metadata, device }, (error, resolved) =>
      return callback error if error?
      @_runEngine {resolved, rules: @rulesConfig.if}, (error, events) =>
        return callback error, events if (error? || !_.isEmpty(events))
        @_runEngine {resolved, rules: @rulesConfig.else}, callback
    return null

  _runEngine: ({resolved, rules}, callback) =>
    engine = new Engine _.values(rules)
    @_addOperators engine
    engine
      .run resolved
      .then (events) => return callback null, @_templateEvents {resolved, events}
      .catch (error) => callback error

  _templateEvents: ({resolved, events}) =>
    _.map events, (event) => christacheio event, resolved, recurseDepth: 5

  _addOperators: (engine) =>
    engine.addOperator 'exists', @_existentialOperator

  _existentialOperator: (factValue, jsonValue) =>
    return (factValue != undefined) == jsonValue

module.exports = MeshbluRulesEngine
