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

  describe "lookup", ->
    before (done) ->
      @dataviews.eagerLoad "cherrytree",
        harvest: "june"
      .then (cherrytree) =>
        @cherrytree = cherrytree
        done()
    it "should properly create and register a default dataview", ->
      expect @cherrytree
      .to.have.property "dataviewName", "cherrytree"

    it "should have the default load which just passes a model through", ->
      expect @cherrytree.get("model")
      .to.deep.equal harvest: "june"

    describe "store", ->
      before ->
        @store = @cherrytree.get("store")
      it "should have a store", ->
        expect @store
        .to.be.ok
    describe "dataviews", ->
      it "should have a handle back to the dataviews service", ->
        expect @cherrytree.get("dataviews")
        .to.equal @dataviews

  describe "normalize", ->
    it "should properly return a name", ->
      expect @dataviews.normalize "appletree"
      .to.equal "dataview:appletree"
    it "should work on longer names", ->
      expect @dataviews.normalize "dashboard.projects.new"
      .to.equal "dataview:dashboard/projects/new"
  describe "lookupFactory", ->
    before ->
      @appletreeFactory = @dataviews.lookupFactory "appletree"
    it "should find the appletree", ->
      expect(Ember.typeOf @appletreeFactory).to.equal "class"

  describe "eagerLoad", ->
    before (done) ->
      @dataviews.eagerLoad "appletree"
      .then (appletree) =>
        @appletree = appletree
        done()
    it "should have the right dataviewName", ->
      expect(@appletree).to.have.property("dataviewName", "appletree")
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
    before (done) ->
      @dataviews.lazyLoad "appletree"
      .then (appletree) =>
        @appletree = appletree
        done()
    it "resolves promise values", ->
      expect(@appletree).to.have.property("tree", "promise")
    it "handles regular values", ->
      expect(@appletree).to.have.property("birds", "birds")
    it "handles its own context correct", ->
      expect(@appletree).to.have.property("ctx", "granny-smith")
    it "should be able to resolve its owner", ->
      expect(@appletree).to.have.property "lookupEngine"

    describe "instance handling", ->
      before (done) ->
        @dataviews.lazyLoad "appletree"
        .then (appletree) =>
          @appletree2 = appletree
          done()
      it "should not be the same instance", ->
        expect(@appletree).to.not.equal @appletree2
      it "should be testing the right thing", ->
        expect({}).to.not.equal({})
