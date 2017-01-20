MeshbluRulesEngine    = require '../src/models/meshblu-rules-engine'
StartSkypeConfig      = require '../rules/start-skype.cson'
{rules, noevents}      = StartSkypeConfig

describe 'Start Skype', ->
  beforeEach ->

    @sut = new MeshbluRulesEngine StartSkypeConfig

  describe 'when the room is not in skype and has a currentMeeting', ->
    beforeEach (done) ->
      room =
        genisys:
          currentMeeting: 'abra-cadabra'

      @sut.run room, (error, @results) =>
        done error

    it 'should return results', ->
      expect(@results).to.deep.equal [rules.add.event]

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
        expect(@results).to.deep.equal noevents

    describe ' and has no currentMeeting', ->
      beforeEach (done) ->
        room =
          genisys:
            inSkype: true

        @sut.run room, (error, @results) =>
          done error

      it 'should return results', ->
        expect(@results).to.deep.equal noevents
