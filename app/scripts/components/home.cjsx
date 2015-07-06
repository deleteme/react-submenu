React           = require 'react'
PureRenderMixin = require('react/addons').addons.PureRenderMixin
Router          = require('react-router')
Reflux          = require 'Reflux'
Immutable       = require 'Immutable'
Results         = require '../components/results'
Menu            = require '../components/menu'
menuStore       = require '../stores/menu'
resultStore     = require '../stores/results'
resultsActions  = require '../actions/results'


Home = React.createClass

  displayName: 'Home'

  mixins: [PureRenderMixin, Reflux.ListenerMixin, Router.Navigation]

  getInitialState: ->
    {
      menuItems: menuStore.items
      results: resultStore.results
      pagination: resultStore.pagination
      q: @props.currentRoute.getIn(['query', 'q'])
    }

  componentDidMount: ->
    @listenTo menuStore, @onMenuChange
    @listenTo resultStore, @onResultChange

  onMenuChange: (menuItems)->
    @setState { menuItems }

  onResultChange: (results, pagination)->
    @setState { results, pagination }

  search: (e)->
    currentRouteQuery = @props.currentRoute.get 'query'
    q = e.target.value

    path = 'marketplace'
    params = @props.currentRoute.get('params').toJS()
    query = currentRouteQuery.merge(q: q).toJS()

    @setState { q }

    console.log "path, params, query:", path, params, query
    @transitionTo path, params, query
    #resultsActions.query e.target.value

  render: ->
    #console.log 'Home::render', @state.menuItems.toJS()
    <div className="home">
      <div className="hero-unit">
        <input className="search-field"
          value=@state.q
          type="text"
          placeholder="Search Discogs"
          onChange=@search
          autoCapitalize="off"
          autoCorrect="off"
          />
        <Menu items=@state.menuItems currentRoute=@props.currentRoute theme="light" />
      </div>
      <Results results=@state.results
        pagination=@state.pagination
        currentRoute=@props.currentRoute
        />
    </div>

module.exports = Home
