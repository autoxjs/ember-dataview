`import Ember from 'ember'`
`import getOwner from 'ember-getowner-polyfill'`
`import Dataview from '../models/dataview'`

{isBlank, inject: {service}} = Ember
assertPresence = (name, instance) ->
  if isBlank instance
    throw new Error "Expected to find a dataview named '#{name}'"
  instance.dataviewName ?= name
  instance

DataviewsService = Ember.Service.extend
  defaultViewFactory: Dataview
  store: service "store"
  dataviewInitAttrs: (name) ->
    store: @get "store"
    dataviews: @
    dataviewName: name
  normalize: (name) ->
    if isBlank(name)
      throw new Error "dataview name cannot be blank"
    resolveName = name.replace(/\./g, "/")
    if resolveName.match /^\w+:/ then resolveName else "dataview:#{resolveName}"

  lookupFactory: (name) ->
    viewName = @normalize(name)
    assertPresence name, getOwner(@)._lookupFactory(viewName) ? @registerDefaultDataview(viewName)

  registerDefaultDataview: (viewName) ->
    return if isBlank(factory = @get "defaultViewFactory")
    owner = getOwner(@)
    owner.register(viewName, factory)
    owner._lookupFactory(viewName)

  eagerLoad: (name, params) ->
    @lookupFactory(name)
    .create @dataviewInitAttrs name
    .eagerLoad(params)

  lazyLoad: (name, params) ->
    @lookupFactory(name)
    .create @dataviewInitAttrs name
    .lazyLoad(params)

`export default DataviewsService`
