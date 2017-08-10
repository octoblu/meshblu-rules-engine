MeshbluRulesEngine    = require '../src/models/meshblu-rules-engine'
IfElseConfig          = require '../rules/if-else.cson'

describe 'If/Else', ->
  beforeEach ->
    @sut = new MeshbluRulesEngine rulesConfig: IfElseConfig

  describe 'when the first and second conditions are true', ->
    beforeEach (done) ->
      data =
        president: 'HUGH'
        spy: 0x007

      @sut.run {data}, (error, @results) =>
        done error

    it 'should return results', ->
      expect(@results).to.deep.equal [
        type: "info"
        params:
        	text: "small hands"
      ]

  describe 'when the first condition is false and the second is true', ->
    beforeEach (done) ->
      data =
        president: 'tiny'
        spy: 0x007

      @sut.run {data}, (error, @results) =>
        done error

    it 'should return proper results', ->
      expect(@results).to.deep.equal [
        type: "info"
        params:
        	text: "send in the TLAs"
      ]

  describe 'when the first and second conditions are false', ->
    beforeEach (done) ->
      data =
        president: 'tiny'
        notSpy: 0x007

      @sut.run {data}, (error, @results) =>
        done error

    it 'should return no results', ->
      expect(@results).to.deep.equal []
