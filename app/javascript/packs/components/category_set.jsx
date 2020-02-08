// Show a set of category buttons with a title

import React from 'react'

import CategoryButton from './category_button'

const CategorySetButton = (props) => {
  const categoryButton = (category) => {
    return (
      <CategoryButton
        key={category}
        category={category}
        onClick={props.onClick}
      />
    )
  }

  const buttons = props.categories.map(categoryButton)

  return (
    <div>
      <div className="diminutive-title">
        {props.title}
        :
      </div>
      <div className="category-buttons">
        {buttons}
      </div>
    </div>
  )
}

export default CategorySetButton
