`import Ember from 'ember'`
`import { describe, it, before, after } from 'mocha'`
`import { expect } from 'chai'`
`import startApp from '../helpers/start-app'`
`import destroyApp from '../helpers/destroy-app'`

describe 'Acceptance: Dataview', ->
  before (done) ->
    @application = startApp()
    @container = @application.__container__
    @dataviews = @container.lookup "service:dataviews"
    visit "/"
    andThen -> done()

  after ->
    Ember.run @application, 'destroy'

  describe "normalize", ->
    it "should properly return a name", ->
      expect @dataviews.normalize "appletree"
      .to.equal "dataview:appletree"
    it "should work on longer names", ->
      expect @dataviews.normalize "dashboard.projects.new"
      .to.equal "dataview:dashboard/projects/new"
  describe "lookup", ->
    before ->
      @appletree = @dataviews.lookup "appletree"
    it "should find the appletree", ->
      expect(Ember.typeOf @appletree).to.equal "instance"

  describe "eagerLoad", ->
    after -> @appletree.reset()
    before (done) ->
      @dataviews.eagerLoad "appletree"
      .then (appletree) =>
        @appletree = appletree
        done()
    it "resolves promise values", ->
      expect(@appletree).to.have.property("tree", "promise")
    it "handles regular values", ->
      expect(@appletree).to.have.property("birds", "birds")
    describe "flower", ->
      before ->
        @flower = @appletree.get("flower")
      it "should have resolved the flower", ->
        expect(@flower).to.have.property "dataviewLoadStatus", "loaded"
      it "should have the right value", ->
        expect(@flower).to.have.property "bloom", true
  describe "lazyLoad", ->
    after -> @appletree.reset()
    before (done) ->
      @dataviews.lazyLoad "appletree"
      .then (appletree) =>
        @appletree = appletree
        done()
    it "resolves promise values", ->
      expect(@appletree).to.have.property("tree", "promise")
    it "handles regular values", ->
      expect(@appletree).to.have.property("birds", "birds")

    describe "singleton persistance", ->
      before ->
        @appletree2 = @container.lookup "dataview:appletree"
      it "should be the same instance", ->
        expect(@appletree).to.equal @appletree2
      it "should be testing the right thing", ->
        expect({}).to.not.equal({})
