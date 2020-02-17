// Show a set of category buttons with a title

import React, { Component } from 'react'

import CategoryButton from './category_button'
import FilterBox from './filter_box'

class CategorySetButton extends Component {
  categoryButton = (category) => (
    <CategoryButton
      key={category.id}
      category={category}
      onClick={this.props.onClick}
      suggested={this.props.suggested}
    />
  )

  filterDidChange = (e) => {
    this.props.filterDidChange(e.target.value)
  }

  filter = () => {
    if (this.props.filter === undefined) {
      return null
    }

    return (
      <div>
        <FilterBox
          clearFilter={this.props.clearFilterClicked}
          filterDidChange={this.filterDidChange}
          value={this.props.filter}
        />
      </div>
    )
  }

  buttons = () => {
    const buttons = this.props.categories.map((category) => {
      if (category.hidden) {
        return null
      }

      return this.categoryButton(category)
    })

    return (
      <div>
        {buttons}
      </div>
    )
  }

  render() {
    return (
      <div>
        <div className="diminutive-title">
          {this.props.title}
          :
        </div>
        {this.filter()}
        <div className="category-buttons">
          {this.buttons()}
        </div>
      </div>
    )
  }
}

export default CategorySetButton
