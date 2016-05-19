`import Ember from 'ember'`
`import _ from 'lodash/lodash'`

{A, RSVP, inject: {service}} = Ember
{bind, chain, partialRight} = _

resolveAp = (f, params) ->
  RSVP.resolve f params
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
    .mapValues partialRight(resolveAp, params)
    .thru RSVP.hash
    .value()
    .then (hash) => @setProperties hash
    .then => @
    .finally => @set "dataviewLoadStatus", "loaded"

  reset: ->
    dataviews = @get "dataviews"
    @set "dataviewLoadStatus", "unloaded"
    dataviews.reset(viewName) for viewName in @childViews

  childViews: []
  loads:
    default: RSVP.resolve

`export default Dataview`
