MeshbluRulesEngine    = require '../src/models/meshblu-rules-engine'
StartSkypeRuleAdd     = require '../rules/start-skype-add.cson'
StartSkypeRuleRemove  = require '../rules/start-skype-remove.cson'
EndSkypeRule          = require '../rules/end-skype.cson'

describe 'MeshbluRulesEngine', ->
  beforeEach ->
    @sut = new MeshbluRulesEngine

  describe 'Start Skype', ->

    describe 'when the room is not in skype and has a currentMeeting', ->
      beforeEach (done) ->
        room =
          genisys:
            currentMeeting: 'abra-cadabra'

        @sut.addRule StartSkypeRuleAdd
        @sut.addRule StartSkypeRuleRemove

        @sut.run room, (error, @results) =>
          done error

      it 'should return results', ->
        expect(@results).to.deep.equal [StartSkypeRuleAdd.event]

    describe 'when the room is in skype', ->

      describe ' and has a currentMeeting', ->
        beforeEach (done) ->
          room =
            genisys:
              inSkype: true
              currentMeeting: 'abra-cadabra'

          @sut.addRule StartSkypeRuleAdd
          @sut.addRule StartSkypeRuleRemove

          @sut.run room, (error, @results) =>
            done error

        it 'should return results', ->
          expect(@results).to.deep.equal [StartSkypeRuleRemove.event]

      describe ' and has no currentMeeting', ->
        beforeEach (done) ->
          room =
            genisys:
              inSkype: true

          @sut.addRule StartSkypeRuleAdd
          @sut.addRule StartSkypeRuleRemove

          @sut.run room, (error, @results) =>
            done error

        it 'should return results', ->
          expect(@results).to.deep.equal [StartSkypeRuleRemove.event]

  describe 'End Skype', ->

    describe 'when the room is in skype', ->
      beforeEach (done) ->
        room =
          genisys:
            inSkype: true

        @sut.addRule EndSkypeRule
        @sut.run room, (error, @results) =>
          done error

      it 'should return results', ->
        expect(@results).to.deep.equal [EndSkypeRule.event]

    describe 'when the room is not in skype', ->
      beforeEach (done) ->
        room =
          genisys: {}

        @sut.addRule EndSkypeRule
        @sut.run room, (error, @results) =>
          done error

      it 'should return results', ->
        expect(@results).to.be.empty
