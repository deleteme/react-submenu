React = require 'react'


Card = React.createClass

  displayName: 'Card'

  render: ->
    title = @props.data.get('title')
    formats = @props.data.get('format').join ', '
    labels = @props.data.get('label').join ', '
    catno = @props.data.get('catno')
    thumb = @props.data.get('thumb')

    <div className="card" onClick=@log>
      <div className="card-thumb">
        { thumb and <img src=thumb /> }
      </div>
      <div className="card-content">
        <strong>
          <a>{ title }</a> <span>({ formats })</span>
        </strong>
        <br />
        Label: { labels }
        <br />
        Cat #: { catno }
      </div>
      <div className="clear"></div>
    </div>

  log: ->
    console.log "Clicked card:", @props.data.toJS()


Results = React.createClass

  displayName: 'Results'

  render: ->

    hasResults = @props.results.size > 0

    <div className="results">
      <p className="results-summary">
        Viewing { @props.results.size } of { @props.pagination.get('items') } releases
      </p>
      { @props.results.map((result)->
        #console.log "result:", result
        <Card data=result key="result/#{ result.get('id') }" />
      ).toJS() }
    </div>

module.exports = Results
