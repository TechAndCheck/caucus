// Show a set of category buttons with a title

import React from 'react'

const SuggestionBox = (props) => (
  <div className="filter">
    <input type="text" className="form-control" placeholder="Category Suggestion" value={props.value} onChange={props.suggestionDidChange} />
    <button type="button" className="btn btn-secondary btn-sm" onClick={props.onSuggestionSubmit}>Submit</button>
  </div>
)


export default SuggestionBox
