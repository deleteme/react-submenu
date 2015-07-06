React = require 'react'
Router = require 'react-router'
Route = Router.Route
Routes = Router.Routes
DefaultRoute = Router.DefaultRoute

Layout = require './components/layout'
Home = require './components/home'

menuActions = require './actions/menu'

routes = (
	<Route name="layout" path="/" handler={Layout}>
    <Route name="marketplace" handler={Home} />
		<DefaultRoute handler={Home} />
	</Route>
)

h = (Handler, state)->
  menuActions.route(state)
  React.render(<Handler />, document.getElementById('content'))

exports.start = ->
	Router.run routes, h
