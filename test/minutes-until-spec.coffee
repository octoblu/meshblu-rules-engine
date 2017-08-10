MeshbluRulesEngine = require '../src/models/meshblu-rules-engine'
MinutesUntilConfig = require '../rules/minutes-until.cson'
moment             = require 'moment'

describe 'Minutes until operator', ->
  beforeEach ->
    @sut = new MeshbluRulesEngine rulesConfig: MinutesUntilConfig

  describe 'when within the accepted interval', ->
    beforeEach (done) ->
      futureTime = moment().utc().add(6, 'minutes').toISOString()
      data =
        then: futureTime

      @sut.run {data}, (error, @results) =>
        done error

    it 'should return true', ->
      expect(@results).to.deep.equal [
        type: "info"
        params:
        	text: "flux capacitor"
      ]

  describe 'when outside of the accepted interval', ->
    beforeEach (done) ->
      futureTime = moment().utc().add(15, 'minutes').toISOString()
      data =
        then: futureTime

      @sut.run {data}, (error, @results) =>
        done error

    it 'should return false', ->
      expect(@results).to.be.empty
