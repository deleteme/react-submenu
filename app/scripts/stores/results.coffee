Reflux = require 'Reflux'
Immutable = require 'immutable'
$ = require 'jquery'

resultActions = require '../actions/results'
menuActions = require '../actions/menu'

resultsFixtures = [
  {
    "marketplace": {"currency": "$", "quantity": 9, "min": 7.989999771118164},
    "thumb": "http://cdn.discogs.com/QefRoDyIgAre2O2PzYFRJNaSW9c=/100x100/filters:strip_icc():format(jpeg):mode_rgb()/discogs-images/R-1691-1166043913.jpeg.jpg",
    "format": ["Vinyl"],
    "uri": "/Underground-Resistance-Elimination-Gamma-Ray/release/1691",
    "title": "Elimination / Gamma-Ray",
    "artist": "Underground Resistance",
    "type": "Release"
    "genre": ["Electronic"]
    id: 1
  }
  {
    "marketplace": {"currency": "$", "quantity": 9, "min": 7.989999771118164},
    "thumb": "http://cdn.discogs.com/QefRoDyIgAre2O2PzYFRJNaSW9c=/100x100/filters:strip_icc():format(jpeg):mode_rgb()/discogs-images/R-1691-1166043913.jpeg.jpg",
    "format": ["Vinyl"],
    "uri": "/Underground-Resistance-Elimination-Gamma-Ray/release/1691",
    "title": "Elimination / Gamma-Ray",
    "artist": "Underground Resistance",
    "type": "Release"
    "genre": ["Electronic"]
    id: 2
  }
]

resultStore = Reflux.createStore
  init: ->
    @results = Immutable.fromJS []#resultsFixtures
    @pagination = new Immutable.fromJS { items: 0 }
    #@listenTo resultActions.query, @onQueryResults
    @listenTo menuActions.route, @syncWithRoutes

  onQueryResults: ->
    query = @routeState.get('query')
    q = query.get('q')
    console.log 'querying ', q
    url = 'http://api.mattgarrett.local:5000/database/lookup'
    request = $.ajax(url, {
      dataType: 'jsonp'
      crossDomain: true
      data:
        q: q
        per_page: 25
        type: 'release'
        format: query.get('format')
        genre: query.get('genre')
    }).promise()
    request.then @setResults, @queryFail

  queryFail: ->
    console.error 'query failed'

  setResults: (response)->
    console.log 'setResults', response
    @pagination = Immutable.fromJS response.data.pagination
    @results = Immutable.fromJS response.data.results
    @trigger(@results, @pagination)

  syncWithRoutes: (routeState)->
    console.log 'result store syncing with routes', routeState
    previousRouteState = @routeState
    @routeState = Immutable.fromJS routeState
    @onQueryResults() if @routeState isnt previousRouteState

module.exports = resultStore
