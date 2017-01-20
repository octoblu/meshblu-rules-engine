_ = require 'lodash'
{Engine} = require 'json-rules-engine'


class MeshbluRulesEngine
  constructor: ->
    @engine = new Engine

  addRule: (rule) =>
    @engine.addRule rule

  run: (facts, callback) =>
    flatFacts = @_flattenFacts(facts)
    @engine
      .run flatFacts
      .then (events) => callback null, events
      .catch (error) => callback error

  _flattenFacts: (facts, prefix='', flatFacts={}) =>
    _.each facts, (fact, key) =>
      unless _.isPlainObject fact
        flatFacts["#{prefix}#{key}"] = fact
        return true
      @_flattenFacts fact, "#{prefix}#{key}.", flatFacts

    flatFacts

module.exports = MeshbluRulesEngine
