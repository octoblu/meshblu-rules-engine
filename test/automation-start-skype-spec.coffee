MeshbluRulesEngine    = require '../src/models/meshblu-rules-engine'
StartSkypeRules       = require '../rules/start-skype.cson'

describe 'Start Skype', ->
  beforeEach ->
    @sut = new MeshbluRulesEngine
    @sut.addRules StartSkypeRules

  describe 'when the room is not in skype and has a currentMeeting', ->
    beforeEach (done) ->
      room =
        genisys:
          currentMeeting: 'abra-cadabra'

      @sut.run room, (error, @results) =>
        done error

    it 'should return results', ->
      expect(@results).to.deep.equal [StartSkypeRules.add.event]

  describe 'when the room is in skype', ->

    describe ' and has a currentMeeting', ->
      beforeEach (done) ->
        room =
          genisys:
            inSkype: true
            currentMeeting: 'abra-cadabra'

        @sut.run room, (error, @results) =>
          done error

      it 'should return results', ->
        expect(@results).to.deep.equal [StartSkypeRules.remove.event]

    describe ' and has no currentMeeting', ->
      beforeEach (done) ->
        room =
          genisys:
            inSkype: true

        @sut.run room, (error, @results) =>
          done error

      it 'should return results', ->
        expect(@results).to.deep.equal [StartSkypeRules.remove.event]
