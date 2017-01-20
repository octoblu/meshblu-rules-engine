MeshbluRulesEngine = require '../src/models/meshblu-rules-engine'
EndSkypeRule        = require '../rules/end-skype.cson'

describe 'MeshbluRulesEngine', ->
  beforeEach ->
    @sut = new MeshbluRulesEngine

  describe 'End Skype', ->

  describe 'when the room is in skype', ->
    beforeEach (done) ->
      room =
        genisys:
          inSkype: true

      @sut.addRule EndSkypeRule
      @sut.run room, (error, @results) => done error

    it 'should return results', ->
      expect(@results).to.exist
