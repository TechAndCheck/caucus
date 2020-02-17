// An individual category button

import React from 'react'

const CategoryButton = (props) => {
  const buttonClicked = () => {
    props.onClick(props.category)
  }

  if (props.category.hidden) {
    return null
  }

  const classes = () => {
    const classNames = ['btn', 'btn-sm']

    if (props.suggested) {
      classNames.push('btn-info')
    } else {
      classNames.push('btn-primary')
    }

    return classNames.join(' ')
  }

  return (
    <button
      type="button"
      className={classes()}
      onClick={buttonClicked}
    >
      {props.category.name}
    </button>
  )
}

export default CategoryButton
