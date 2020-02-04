// An individual category button

import React from 'react'

const CategoryButton = (props) => {
  const buttonClicked = () => {
    props.onClick(props.categoryName)
  }

  return (
    <button
      type="button"
      className="btn btn-primary btn-sm"
      onClick={buttonClicked}
    >
      {props.categoryName}
    </button>
  )
}

export default CategoryButton
