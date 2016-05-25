`import Ember from 'ember'`
`import _ from 'lodash/lodash'`

{A, RSVP, inject: {service}} = Ember
{bind, chain, bind} = _

resolveAp = (params, f) ->
  RSVP.resolve f.call @, params
Dataview = Ember.Object.extend
  dataviewLoadStatus: "unloaded"
  store: service "store"
  dataviews: service "dataviews"
  lazyLoad: (params) ->
    return RSVP.resolve(@) unless @get("dataviewLoadStatus") is "unloaded"
    @forceLoad()

  eagerLoad: (params) ->
    return RSVP.resolve(@) unless @get("dataviewLoadStatus") is "unloaded"
    @forceLoad params
    .then => RSVP.all A(@childViews).map (viewName) => @childLoad params, viewName
    .then => @

  childLoad: (params, viewName) ->
    @get("dataviews")
    .eagerLoad viewName, params
    .then (dataview) =>
      @set viewName, dataview
      dataview

  forceLoad: (params) ->
    @set "dataviewLoadStatus", "loading"
    chain @loads
    .mapValues bind(resolveAp, @, params)
    .thru RSVP.hash
    .value()
    .then (hash) => 
      @setProperties hash
      @set "dataviewLoadStatus", "loaded"
      @
    .catch (error) ->
      @set "dataviewLoadStatus", "error"
      throw error

  reset: ->
    dataviews = @get "dataviews"
    @set "dataviewLoadStatus", "unloaded"
    dataviews.reset(viewName) for viewName in @childViews

  childViews: []
  loads:
    model: (opts) -> opts

`export default Dataview`
