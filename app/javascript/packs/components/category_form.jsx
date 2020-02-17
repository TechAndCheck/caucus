// An individual category button

import React from 'react'

const CategoryForm = (props) => {
  const extractIds = (categories) => categories.map((category) => category.id)
  const extractNames = (categories) => categories.map((category) => category.name)

  return (
    <div>
      <input type="hidden" name="claim[categories]" value={extractIds(props.categories).join(':::')} />
      <input type="hidden" name="claim[suggestions]" value={extractNames(props.suggestions).join(':::')} />
    </div>
  )
}

export default CategoryForm
