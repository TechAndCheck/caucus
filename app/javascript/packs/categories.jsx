import React, { Component } from 'react'
import ReactDOM from 'react-dom'

import CategoryForm from './components/category_form'
import CategorySet from './components/category_set'

class Categories extends Component {
  constructor(props) {
    super(props)

    this.state = {
      available: props.categories,
      assigned: props.assignedCategories,
    }
  }

  componentDidMount() {
  }

  buttonClicked = (categoryName) => {
    this.setState((state) => {
      let available = state.available
      let assigned = state.assigned

      // Figure out which array contains the categoryName
      if (available.indexOf(categoryName) !== -1) {
        [available, assigned] = this.flipElement(available, assigned, categoryName)
      } else {
        [assigned, available] = this.flipElement(assigned, available, categoryName)
      }

      return { available, assigned }
    })
  }

  flipElement = (fromArray, toArray, element) => {
    // Flip the array then
    const index = fromArray.indexOf(element)
    fromArray.splice(index, 1)
    toArray.push(element)
    return [fromArray, toArray]
  }

  render() {
    return (
      <div>
        <CategoryForm categories={this.state.assigned} />
        <CategorySet title="Assigned Categories" key="assigned" categories={this.state.assigned} onClick={this.buttonClicked} />
        <hr />
        <CategorySet title="Available Categories" key="available" categories={this.state.available} onClick={this.buttonClicked} />
      </div>
    )
  }
}

// Loads the initial data from the dom elements.
const loadDataFromDom = () => {
  const categoriesDiv = document.querySelector('#categories')
  if (categoriesDiv) {
    const categoriesData = JSON.parse(categoriesDiv.getAttribute('data-categories'))
    const assignedCategoriesData = JSON.parse(categoriesDiv.getAttribute('data-assigned-categories'))

    ReactDOM.render(
      <Categories categories={categoriesData} assignedCategories={assignedCategoriesData} />, categoriesDiv,
    )
  }
}

// This can happen either because of a fresh load or because of a turbolinks redirect
document.addEventListener('turbolinks:load', loadDataFromDom)
document.addEventListener('DOMContentLoaded', loadDataFromDom)
