`import Ember from 'ember'`
`import Dataview from 'ember-dataview'`

{RSVP} = Ember
AppletreeDataview = Dataview.extend
  childViews: ["flower", "foliage", "fruit"]
  loads:
    tree: ->
      RSVP.resolve "promise"
    birds: ->
      "birds"


`export default AppletreeDataview`
