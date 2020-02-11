// An individual category button

import React from 'react'

const CategoryForm = (props) => {
  const extractIds = (categories) => categories.map((category) => category.id)

  return (
    <input type="hidden" name="claim[categories]" value={extractIds(props.categories).join(':::')} />
  )
}

export default CategoryForm
