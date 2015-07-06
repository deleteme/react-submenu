React = require 'react'
Immutable = require 'Immutable'
Router = require 'react-router'
RouteHandler = Router.RouteHandler

Layout = React.createClass

  displayName: 'Layout'

  mixins: [Router.State]

  render: ->

    currentRoute = Immutable.fromJS
      params: @getParams()
      query: @getQuery()
      path: @getPath()
      pathname: @getPathname()

    return (
      <div className="App">
        <RouteHandler currentRoute=currentRoute />
      </div>
    )

module.exports = Layout
