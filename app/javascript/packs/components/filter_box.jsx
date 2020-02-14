// Show a set of category buttons with a title

import React from 'react'

const FilterBox = (props) => (
  <div className="filter">
    <input type="text" className="form-control" placeholder="Filter" value={props.value} onChange={props.filterDidChange} />
    <button type="button" className="btn btn-secondary btn-sm" onClick={props.clearFilter}>Clear</button>
  </div>
)


export default FilterBox
