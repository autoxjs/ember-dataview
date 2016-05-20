`import Ember from 'ember'`
`import Dataview from 'ember-dataview'`
`import getOwner from 'ember-getowner-polyfill'`

{RSVP} = Ember
AppletreeDataview = Dataview.extend
  ctxFun: -> "granny-smith"
  childViews: ["flower", "foliage", "fruit"]
  loads:
    lookupEngine: -> 
      getOwner(@)
    ctx: ->
      RSVP.resolve @ctxFun()
    tree: ->
      RSVP.resolve "promise"
    birds: ->
      "birds"


`export default AppletreeDataview`
