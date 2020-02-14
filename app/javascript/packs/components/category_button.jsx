// An individual category button

import React from 'react'

const CategoryButton = (props) => {
  const buttonClicked = () => {
    props.onClick(props.category)
  }

  if (props.category.hidden) {
    return null
  }

  return (
    <button
      type="button"
      className="btn btn-primary btn-sm"
      onClick={buttonClicked}
    >
      {props.category.name}
    </button>
  )
}

export default CategoryButton
