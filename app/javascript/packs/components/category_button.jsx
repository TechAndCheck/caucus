// An individual category button

import React from 'react'

const CategoryButton = (props) => {
  const buttonClicked = () => {
    props.onClick(props.category)
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
