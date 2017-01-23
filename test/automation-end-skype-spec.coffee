MeshbluRulesEngine  = require '../src/models/meshblu-rules-engine'
EndSkypeConfig      = require '../rules/end-skype.cson'
{rules, noevents}   = EndSkypeConfig

describe 'End Skype', ->
  beforeEach ->

    @sut = new MeshbluRulesEngine EndSkypeConfig

  describe 'when the room is in skype', ->

    describe ' and does not have a currentMeeting', ->
      beforeEach (done) ->
        room =
          genisys:
            peopleInRoom: [ 'nobody' ]
            inSkype: true
            devices:
              activities: 'activities-device-uuid'

        @sut.run room, (error, @results) =>
          done error

      it 'should return results', ->
        expect(@results).to.deep.equal [
          type: 'meshblu'
          params:
            operation: 'update'
            uuid: 'activities-device-uuid'
            data:
              $set: 'genisys.activities.endSkype':
                title: 'End Skype'
                jobType: 'end-skype'
                people: [ 'nobody' ]
        ]

    describe ' and has a currentMeeting', ->
      beforeEach (done) ->
        room =
          genisys:
            devices:
              activities: 'activities-device-uuid'
            inSkype: true
            currentMeeting:
              meetingId: 'meeting-uuid'
            people:
              byAttendee:
                isAttendee: [ 'your-mom' ]

        @sut.run room, (error, @results) =>
          done error

      it 'should return results', ->
        expect(@results).to.deep.equal [
          type: 'meshblu'
          params:
            operation: 'update'
            uuid: 'activities-device-uuid'
            data:
              $set: 'genisys.activities.endSkype':
                title: 'End Skype'
                jobType: 'end-skype'
                meetingId: 'meeting-uuid'
                people: ['your-mom']
        ]

  describe 'when the room is not in skype', ->
    beforeEach (done) ->
      room =
        genisys:
          inSkype: false
          devices:
            activities: 'activities-device-uuid'

      @sut.run room, (error, @results) =>
        done error

    it 'should return results', ->
      expect(@results).to.deep.equal [
        type: 'meshblu'
        params:
          operation: 'update'
          uuid: 'activities-device-uuid'
          data:
            'genisys.activities.endSkype.people': []
      ]
