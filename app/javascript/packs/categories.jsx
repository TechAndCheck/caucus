import React, { Component } from 'react'
import ReactDOM from 'react-dom'

import CategorySet from './components/category_set'

class Categories extends Component {
  constructor(props) {
    super(props)

    this.state = {
      available: ['war', 'impeachment', 'Iraq'],
      assigned: ['Terrorism'],
    }
  }

  componentDidMount() {
  }

  buttonClicked = (categoryName) => {
    console.log(`${categoryName} clicked`)
  }

  render() {
    return (
      <div>
        <CategorySet title="Assigned Categories" categories={this.state.assigned} onClick={this.buttonClicked} />
        <hr />
        <CategorySet title="Available Categories" categories={this.state.available} onClick={this.buttonClicked} />
      </div>
    )
  }
}

// Loads the initial data from the dom elements.
const loadDataFromDom = () => {
  const categoriesDiv = document.querySelector('#categories')
  if (categoriesDiv) {
    ReactDOM.render(
      <Categories />, categoriesDiv,
    )
  }
}

// This can happen either because of a fresh load or because of a turbolinks redirect
document.addEventListener('turbolinks:load', loadDataFromDom)
document.addEventListener('DOMContentLoaded', loadDataFromDom)
