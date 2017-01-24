_ = require 'lodash'
{Engine} = require 'json-rules-engine'
christacheio = require 'christacheio'
RefResolver = require 'meshblu-json-schema-resolver'
class MeshbluRulesEngine
  constructor: ({@rulesConfig, @meshbluConfig})->

    @engine = new Engine _.values @rulesConfig.rules
    @engine.addOperator 'exists', @_existentialOperator    

  run: ({data={}, metadata={}, device={}}, callback) =>
    resolver = new RefResolver {@meshbluConfig}
    resolver.resolve {data, metadata, device}, (error, resolved) =>
      return callback error if error?
      @engine
        .run resolved
        .then (events) =>
          events = @rulesConfig.noevents || [] if _.isEmpty events
          return callback null, @_templateEvents {resolved, events}
        .catch (error) => callback error
    return null


  _templateEvents: ({resolved, events}) =>
    _.map events, (event) => christacheio event, resolved

  _existentialOperator: (factValue, jsonValue) =>
    return (factValue != undefined) == jsonValue

module.exports = MeshbluRulesEngine
