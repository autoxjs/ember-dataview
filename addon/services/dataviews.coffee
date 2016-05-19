`import Ember from 'ember'`
`import getOwner from 'ember-getowner-polyfill'`
{isBlank} = Ember
assertPresence = (name, factory) ->
  if isBlank factory
    throw new Error "Expected to find a dataview named '#{name}'"
  factory

DataviewsService = Ember.Service.extend
  views: {}
  normalize: (name) ->
    if isBlank(name)
      throw new Error "dataview name cannot be blank"
    resolveName = name.replace(/\./g, "/")
    if resolveName.match /^\w+:/ then resolveName else "dataview:#{resolveName}"

  lookup: (name) ->
    assertPresence name, getOwner(@).lookup @normalize(name)

  eagerLoad: (name, params) ->
    @lookup(name).eagerLoad(params)

  lazyLoad: (name, params) ->
    @lookup(name).lazyLoad(params)

  reset: (name) ->
    @lookup(name).reset()

`export default DataviewsService`
