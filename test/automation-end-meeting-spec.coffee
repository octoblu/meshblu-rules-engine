MeshbluRulesEngine  = require '../src/models/meshblu-rules-engine'
EndMeeting          = require '../rules/end-meeting.cson'
{rules}             = EndMeeting

describe 'End Meeting', ->
  beforeEach ->

    @sut = new MeshbluRulesEngine EndMeeting

  describe 'when the room is not in skype and has a currentMeeting', ->
    beforeEach (done) ->
      room =
        uuid: 'some-room-group-uuid'
        genisys:
          devices:
            activities: 'some-activities-device-uuid'
          inSkype: true
          currentMeeting:
            meetingId: 'another-meeting-uuid'
          people:
            byAttendee:
              isAttendee: [ 'conference-people' ]

      @sut.run room, (error, @results) =>
        done error

    it 'should return results', ->
      expect(@results).to.deep.equal [
        type: 'meshblu'
        params:
          operation: 'update'
          uuid: 'some-activities-device-uuid'
          as: 'some-room-group-uuid'
          data:
            $set: 'genisys.activities.endMeeting':
              title: 'End Meeting'
              jobType: 'end-meeting'
              meetingId: 'another-meeting-uuid'
              data:
                meetingId: 'another-meeting-uuid'
              people: [ 'conference-people' ]
      ]
