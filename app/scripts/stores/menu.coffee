Reflux = require 'Reflux'
Router = require 'react-router'
Immutable = require 'Immutable'

actions = require '../actions/menu'

recursiveSetInList = (list, id, prop, value)->
  list.map (map)->
    recursiveSet map, id, prop, value

recursiveSet = (map, id, prop, value)->
  #console.log 'recursiveSet'
  if map.get('id') is id
    map.set prop, value
  else if map.get('links')?.size > 0
    map.set 'links', recursiveSetInList map.get('links'), id, prop, value
  else
    map

# An item's selected state depends on if it matches the queryKey or queryValue
setSelectedFromQuery = (items, query)->
  selectedIds = []

  for key of query
    selectedIds.push key
    selectedIds.push "#{ key }/#{ query[key] }"

  setSelectedIfInSet = (item)->
    selected = selectedIds.indexOf(item.get('id')) >= 0
    item.set 'selected', selected

  items.map (item)->
    item = setSelectedIfInSet item
    if item.get('links')?.size > 0
      item = item.set('links', item.get('links').map((it)->
        it = setSelectedIfInSet it
      ))
    item


genres = [
  "Electronic",
  "Rock",
  "Pop",
  "Funk / Soul",
  "Hip Hop",
  "Jazz",
  "Folk, World, & Country",
  "Reggae",
  "Stage & Screen",
  "Classical",
  "Blues",
  "Latin",
  "Non-Music",
  "Children's",
  "Brass & Military"
].map (genre)->
  {
    name: genre,
    id: "genre/#{ genre.toLowerCase() }",
    selected: false,
    query: genre: genre.toLowerCase().replace(' ', '+')
  }


menuStore = Reflux.createStore
  init: ->
    @items = Immutable.fromJS [
      { name: 'Format', id: 'format', selected: false, links: [
        { name: 'Vinyl', id: 'format/vinyl', selected: false, query: format: 'vinyl' }
        { name: 'CD', id: 'format/cd', selected: false, query: format: 'cd' }
        { name: 'Cassette', id: 'format/cassette', selected: false, query: format: 'cassette' }
        { name: "CDr", id: 'format/cdr', selected: false, query: format: 'cdr' }
        { name: "DVD", id: 'format/dvd', selected: false, query: format: 'dvd' }
        { name: "Box Set", id: 'format/box-set', selected: false, query: format: 'box-set' }
        { name: "All Media", id: 'format/all-media', selected: false, query: format: 'all-media' }
        { name: "Flexi-disc", id: 'format/flexi-disc', selected: false, query: format: 'flexi-disc' }
        { name: "Shellac", id: 'format/shellac', selected: false, query: format: 'shellac' }
        { name: "VHS", id: 'format/vhs', selected: false, query: format: 'vhs' }
      ] }
      { name: 'Currency', id: 'currency', selected: false, links: [
        { name: 'EUR €', id: 'currency/eur', selected: false, query: currency: 'eur' }
        { name: 'USD $', id: 'currency/usd', selected: false, query: currency: 'usd' }
        { name: 'GBP £', id: 'currency/gbp', selected: false, query: currency: 'gbp' }
        { name: 'AUD A$', id: 'currency/aud', selected: false, query: currency: 'aud' }
        { name: 'CAD CA$', id: 'currency/cad', selected: false, query: currency: 'cad' }
        { name: 'CHF', id: 'currency/chf', selected: false, query: currency: 'chf' }
        { name: 'SEK', id: 'currency/sek', selected: false, query: currency: 'sek' }
        { name: 'JPY ¥', id: 'currency/jpy', selected: false, query: currency: 'jpy' }
        { name: 'NZD NZ$', id: 'currency/nzd', selected: false, query: currency: 'nzd' }
        { name: 'ZAR', id: 'currency/zar', selected: false, query: currency: 'zar' }
        { name: 'BRL', id: 'currency/brl', selected: false, query: currency: 'brl' }
        { name: 'MXN', id: 'currency/mxn', selected: false, query: currency: 'mxn' }
      ] }
      { name: 'Genre', id: 'genre', selected: false, links: genres }
    ]
    @listenTo actions.select, @select
    @listenTo actions.deselect, @deselect
    @listenTo actions.route, @syncWithRoutes

  syncWithRoutes: (state)->
    console.log('syncWithRoutes incoming:', state)
    newItems = @items

    newItems = setSelectedFromQuery newItems, state.query

    if newItems and newItems isnt @items
      @items = newItems
      console.log 'triggering from sync with routes', @items.toJS()
      @trigger @items


  select: (id)->
    #console.log 'items is ', @items
    # find the object with the id and select it
    @items = recursiveSetInList @items, id, 'selected', true
    @trigger @items

  deselect: (id)->
    # find the object with the id and deselect it
    @items = recursiveSetInList @items, id, 'selected', false
    @trigger @items

window.menuStore = menuStore

module.exports = menuStore
