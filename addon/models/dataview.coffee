`import Ember from 'ember'`
`import _ from 'lodash/lodash'`

{A, RSVP, inject: {service}} = Ember
{bind, chain, bind} = _

resolveAp = (params, f) ->
  RSVP.resolve f.call @, params
Dataview = Ember.Object.extend
  dataviewLoadStatus: "unloaded"

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
    @set "dataviewLoadStatus", "unloaded"

  childViews: []
  loads:
    model: (opts) -> opts

`export default Dataview`
