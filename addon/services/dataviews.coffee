`import Ember from 'ember'`
`import getOwner from 'ember-getowner-polyfill'`
`import Dataview from '../models/dataview'`

{isBlank} = Ember
assertPresence = (name, instance) ->
  if isBlank instance
    throw new Error "Expected to find a dataview named '#{name}'"
  instance.dataviewName ?= name
  instance

DataviewsService = Ember.Service.extend
  defaultViewFactory: Dataview

  normalize: (name) ->
    if isBlank(name)
      throw new Error "dataview name cannot be blank"
    resolveName = name.replace(/\./g, "/")
    if resolveName.match /^\w+:/ then resolveName else "dataview:#{resolveName}"

  lookup: (name) ->
    viewName = @normalize(name)
    assertPresence name, getOwner(@).lookup(viewName) ? @defaultDataview(viewName)

  defaultDataview: (viewName) ->
    return if isBlank(factory = @get "defaultViewFactory")
    owner = getOwner(@)
    owner.register(viewName, factory)
    owner.lookup(viewName)

  eagerLoad: (name, params) ->
    @lookup(name).eagerLoad(params)

  lazyLoad: (name, params) ->
    @lookup(name).lazyLoad(params)

  reset: (name) ->
    @lookup(name).reset()

`export default DataviewsService`
