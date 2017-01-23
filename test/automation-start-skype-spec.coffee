MeshbluRulesEngine    = require '../src/models/meshblu-rules-engine'
StartSkypeConfig      = require '../rules/start-skype.cson'
{rules, noevents}      = StartSkypeConfig

xdescribe 'Start Skype', ->
  beforeEach ->

    @sut = new MeshbluRulesEngine StartSkypeConfig

  describe 'when the room is not in skype and has a currentMeeting', ->
    beforeEach (done) ->
      room =
        genisys:
          currentMeeting:
            meetingId: 'current-meeting-uuid'
          devices:
            activities: 'activities-device-uuid'
          people:
            byAttendee:
              isAttendee: [
                {uuid: 'person-1'}
                {uuid: 'person-2'}
              ]

      @sut.run room, (error, @results) =>
        done error

    it 'should return results', ->
      expect(@results).to.deep.equal [
        type: 'meshblu'
        params:
          operation: 'update'
          uuid: 'activities-device-uuid'
          data:
            $set:
              "genisys.activities.startSkype":
                title: "Start Skype",
                jobType: "start-skype",
                meetingId: "current-meeting-uuid",
                people: [
                  {uuid: 'person-1'}
                  {uuid: 'person-2'}
                ]
      ]

  describe 'when the room is in skype', ->

    describe ' and has a currentMeeting', ->
      beforeEach (done) ->
        room =
          genisys:
            inSkype: true
            currentMeeting:
              meetingId: 'current-meeting-uuid'
            devices:
              activities: 'activities-device-uuid'
            people:
              byAttendee:
                isAttendee: [
                  {uuid: 'person-1'}
                  {uuid: 'person-2'}
                ]

        @sut.run room, (error, @results) =>
          done error

      it 'should return results', ->
        expect(@results).to.deep.equal [
          type: 'meshblu'
          params:
            uuid: "activities-device-uuid"
            operation: 'update'
            data:
              $set:
                "genisys.activities.startSkype.people": []
        ]

    describe ' and has no currentMeeting', ->
      beforeEach (done) ->
        room =
          genisys:
            inSkype: true
            devices:
              activities: 'activities-device-uuid'

        @sut.run room, (error, @results) =>
          done error

      it 'should return results', ->
        expect(@results).to.deep.equal [
          type: 'meshblu'
          params:
            uuid: "activities-device-uuid"
            operation: 'update'
            data:
              $set:
                "genisys.activities.startSkype.people": []
        ]
