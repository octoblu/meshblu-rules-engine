_            = require 'lodash'
async        = require 'async'
{Engine}     = require 'json-rules-engine'
christacheio = require 'christacheio'
RefResolver  = require 'meshblu-json-schema-resolver'
moment       = require 'moment'

class MeshbluRulesEngine
  constructor: ({@rulesConfig, @meshbluConfig, @skipRefResolver})->

  run: ({data={}, metadata={}, device={}, fromDevice={}}, callback) =>
    unref = {
      data,
      metadata,
      device,
      fromDevice
    }
    async.parallel {
      data: async.apply @_resolve, data
      metadata: async.apply @_resolve, metadata
      device: async.apply @_resolve, device
      fromDevice: async.apply @_resolve, fromDevice
    }, (error, resolved) =>
      return callback error if error?
      options = _.merge resolved, {unref}
      @_runEngine {options, rules: @rulesConfig.if}, (error, results) =>
        return callback error, results if (error? || !_.isEmpty(results.events))
        @_runEngine {options, rules: @rulesConfig.else}, callback
    return null

  _resolve: (obj, callback) =>
    return callback null, obj if @skipRefResolver

    resolver = new RefResolver {@meshbluConfig}
    resolver.resolve obj, callback

  _runEngine: ({options, rules}, callback) =>
    engine = new Engine _.values(rules)
    @_addOperators engine
    engine
      .run options
      .then (rawEvents) =>
        events = @_templateEvents {options, rawEvents}
        return callback null, { rawEvents, events }
      .catch (error) => callback error

  _templateEvents: ({options, rawEvents}) =>
    _.map rawEvents, (event) => christacheio event, options, recurseDepth: 5

  _addOperators: (engine) =>
    engine.addOperator 'exists', @_existentialOperator
    engine.addOperator 'minutesUntil', @_minutesUntilOperator

  _existentialOperator: (factValue, jsonValue) =>
    return (factValue != undefined) == jsonValue

  _minutesUntilOperator: (factValue, jsonValue) =>
    currentTime = moment().utc()
    startTime = moment(factValue)
    distance = startTime.diff(currentTime, 'minutes')
    return (distance <= jsonValue)

module.exports = MeshbluRulesEngine
