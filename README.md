# Ember-dataview

Introduces the concept of dataviews (inspired by what the couchdb guys are doing).

Dataviews have a store and can be composed of other dataviews

>note: this is alpha software!

## Why?
Because my route files were getting bloated

declare dataviews in their own directory `dataviews/dashboard.coffee`
```coffeescript
DashboardDataview = Dataview.extend
  childViews: ["someOtherView", "anotherView"]
  loads:
    user: (opts) ->
      @store.findRecord "user", opts.id
    fields: (opts) ->
      # load fields

```

Use in the routes `routes/dashboard.coffee`
```coffeescript
Route.extend
  model: ->
    @dataviews.eagerLoad "dashboard",
      routeAction: @get "routeAction"
      routeName: @get "routeName"
```
`eagerLoad` forces your entire dataview tree, while the counterpart `lazyLoad` just loads the head node

## Installation

* `git clone` this repository
* `npm install`
* `bower install`

## Running

* `ember server`
* Visit your app at http://localhost:4200.

## Running Tests

* `npm test` (Runs `ember try:testall` to test your addon against multiple Ember versions)
* `ember test`
* `ember test --server`

## Building

* `ember build`

For more information on using ember-cli, visit [http://ember-cli.com/](http://ember-cli.com/).
