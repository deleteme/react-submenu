React = require 'react'
Router = require 'react-router'
Link = Router.Link
PureRenderMixin = require('react/addons').addons.PureRenderMixin
Immutable = require 'immutable'
actions = require '../actions/menu'

selectedWithLinks = (item)->
  item.get('selected') and item.get('links')?.size > 0

classSet = require '../lib/class-set'

Menu = React.createClass

  displayName: 'Menu'

  mixins: [PureRenderMixin]

  render: ->
    currentRoute = @props.currentRoute
    itemsArray = @props.items.toArray()
    <div className="menu menu-#{ @props.theme or 'dark' }">
      <MenuList items=@props.items
        key="menu-0"
        currentRoute=currentRoute />
      { itemsArray
        .filter(selectedWithLinks)
        .map((menuItem, i)->
          <MenuList items=menuItem.get('links')
            key="submenu-#{ i }-#{ menuItem.get('id') }"
            currentRoute=currentRoute
            />
      ) }
    </div>

MenuList = React.createClass

  displayName: 'MenuList'

  mixins: [PureRenderMixin]

  render: ->
    currentRoute = @props.currentRoute
    itemsArray = @props.items.toArray()
    <div className="horizontal-menu">
      <ul className="horizontal-menu-list">
        { itemsArray.map((menuItem)->
          <MenuItem item={ menuItem }
            key={ menuItem.get('id') }
            currentRoute=currentRoute
            />
        ) }
      </ul>
    </div>


MenuItem = React.createClass

  displayName: "MenuItem"

  mixins: [PureRenderMixin, Router.Navigation]

  getInitialState: ->
    { isFilter: false }

  componentDidMount: ->
    @setState { isFilter: @props.item.has('query') }

  toggleSelected: ->
    #console.log 'MenuItem::toggleSelected()'
    id = @props.item.get 'id'
    selected = @props.item.get 'selected'
    if not @state.isFilter and not selected
      actions.select id
    else
      actions.deselect id
    #if not @state.isFilter
      #if selected
        #actions.deselect id
      #else
        #actions.select id
    return

  #handleTouchTap: (e)->
    #@transitionTo 'marketplace'
    #e.stopPropagation()
    #e.preventDefault()


  render: ->
    { name, query, selected } = @props.item.toJS()

    isFilter = @state.isFilter
    currentRouteQuery = @props.currentRoute.get 'query'

    if isFilter
      # if already in the current route, remove it
      [key, value] = Immutable.List(@props.item.get('query')).toArray()[0]
      if currentRouteQuery.get(key) is value
        newQuery = currentRouteQuery.delete(key)
      # else, add it
      else
        newQuery = currentRouteQuery.merge(query)
    else
      if currentRouteQuery.get(@props.item.get('id'))
        newQuery = currentRouteQuery.delete(@props.item.get('id'))
      else
        newQuery = currentRouteQuery

    newQuery = newQuery.toJS()



    <li
      className={ classSet({
        "menu-item-selected": selected
      }) }
    >
      <Link to="marketplace" query=newQuery onClick=@toggleSelected>
        { name }
      </Link>
    </li>

module.exports = Menu
