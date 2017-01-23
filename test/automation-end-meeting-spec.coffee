MeshbluRulesEngine  = require '../src/models/meshblu-rules-engine'
EndMeeting          = require '../rules/end-meeting.cson'
{rules}             = EndMeeting

xdescribe 'End Meeting', ->
  beforeEach ->

    @sut = new MeshbluRulesEngine EndMeeting

  describe 'when the room is not in skype and has a currentMeeting', ->
    beforeEach (done) ->
      room =
        genisys:
          currentMeeting: 'abra-cadabra'

      @sut.run room, (error, @results) =>
        done error

    it 'should return results', ->
      expect(@results).to.deep.equal [rules.addPeopleInRoom.event]
