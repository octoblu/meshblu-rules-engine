MeshbluRulesEngine    = require '../src/models/meshblu-rules-engine'
EndSkypeConfig      = require '../rules/end-skype.cson'
{rules, noevents}      = EndSkypeConfig

describe 'End Skype', ->
  beforeEach ->

    @sut = new MeshbluRulesEngine EndSkypeConfig

  describe 'when the room is in skype', ->

    describe ' and has a currentMeeting', ->
      beforeEach (done) ->
        room =
          genisys:
            inSkype: true

        @sut.run room, (error, @results) =>
          done error

      it 'should return results', ->
        expect(@results).to.deep.equal [rules.addPeopleInRoom.event]

    describe ' and has no currentMeeting', ->
      beforeEach (done) ->
        room =
          genisys:
            inSkype: true
            currentMeeting: 'abra-cadabra'

        @sut.run room, (error, @results) =>
          done error

      it 'should return results', ->
        expect(@results).to.deep.equal [rules.addPeopleByAttendee.event]

  describe 'when the room is not in skype', ->
    beforeEach (done) ->
      room =
        genisys:
          inSkype: false

      @sut.run room, (error, @results) =>
        done error

    it 'should return results', ->
      expect(@results).to.deep.equal noevents
