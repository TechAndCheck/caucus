import React, { Component } from 'react'
import ReactDOM from 'react-dom'

import _ from 'lodash'
import FuzzySet from 'fuzzyset.js'

import CategoryForm from './components/category_form'
import CategorySet from './components/category_set'
import SuggestionBox from './components/suggestion_box'

class Categories extends Component {
  constructor(props) {
    super(props)

    const addHiddenToCategories = (categories) => (
      categories.map((category) => {
        const categoryClone = _.cloneDeep(category)
        categoryClone.hidden = false
        return categoryClone
      })
    )

    const available = addHiddenToCategories(props.categories)
    const assigned = addHiddenToCategories(props.assignedCategories)

    const fuzzySet = this.setupFuzzySet(props.categories)

    this.state = {
      available,
      assigned,
      suggestions: [],
      visibleAvailable: available,
      fuzzySet,
      filter: '',
      suggestionText: '',
    }
  }

  setupFuzzySet = (categories) => {
    const fuzzySet = FuzzySet()
    categories.forEach((category) => {
      fuzzySet.add(category.name)
    })

    return fuzzySet
  }

  filterDidChange = (filter) => {
    const results = this.state.fuzzySet.get(filter, [], 0)
    let categories = this.categoriesFromSearch(results)

    if (categories.length === 0) {
      categories = this.state.available
    }
    this.setState({
      filter,
      visibleAvailable: categories,
    })
  }

  categoriesFromSearch = (searchResults) => {
    if (!searchResults) {
      return []
    }

    const categories = this.props.categories

    return searchResults.map((result) => (
      _.find(categories, { name: result[1] })
    ))
  }

  buttonClicked = (category) => {
    this.setState((state) => {
      const visibleAvailable = _.cloneDeep(state.visibleAvailable)
      const available = _.cloneDeep(state.available)
      const assigned = _.cloneDeep(state.assigned)

      // Figure out which array contains the categoryName
      const assignedIndex = _.findIndex(assigned, { name: category.name })
      if (assignedIndex !== -1) {
        // If it's in assigned, we'll remove it and unhide in available
        _.pullAt(assigned, assignedIndex)
        const categoryToShow = _.find(available, { name: category.name })
        categoryToShow.hidden = false

        const visibleCategoryToChange = _.find(visibleAvailable, { name: category.name })
        visibleCategoryToChange.hidden = false
      } else {
        // If it's in available, we'll hide it and add it to assigned
        const categoryToAdd = _.find(available, { name: category.name })
        assigned.push(_.cloneDeep(categoryToAdd))
        categoryToAdd.hidden = true

        const visibleCategoryToChange = _.find(visibleAvailable, { name: category.name })
        visibleCategoryToChange.hidden = true
      }

      return { assigned, available, visibleAvailable }
    })
  }

  clearFilterClicked = () => {
    this.setState((state) => (
      {
        filter: '',
        visibleAvailable: state.available,
      }
    ))
  }

  suggestionTextDidChange = (e) => {
    const value = e.target.value
    this.setState({ suggestionText: value })
  }

  onSuggestionSubmit = () => {
    this.setState((state) => {
      const suggestions = _.cloneDeep(state.suggestions)
      suggestions.push({ id: Math.floor((Math.random() * 1000) + 1), name: state.suggestionText })
      return { suggestions, suggestionText: '' }
    })
  }

  onSuggestionButtonClicked = (category) => {
    this.setState((state) => {
      const suggestions = _.cloneDeep(state.suggestions)

      // Figure out which array contains the categoryName
      const suggestionsIndex = _.findIndex(suggestions, { name: category.name })
      if (suggestionsIndex !== -1) {
        // If it's in suggestions, we'll remove it
        _.pullAt(suggestions, suggestionsIndex)
      }

      return { suggestions }
    })
  }

  render() {
    return (
      <div>
        <CategoryForm
          categories={this.state.assigned}
          suggestions={this.state.suggestions}
        />
        <CategorySet
          title="Assigned Categories"
          key="assigned"
          categories={this.state.assigned}
          onClick={this.buttonClicked}
        />
        <CategorySet
          title="Suggested Categories"
          key="suggestions"
          categories={this.state.suggestions}
          onClick={this.onSuggestionButtonClicked}
          suggested
        />
        <hr />
        <CategorySet
          title="Available Categories"
          key="available"
          categories={this.state.visibleAvailable}
          onClick={this.buttonClicked}
          filter={this.state.filter}
          filterDidChange={this.filterDidChange}
          clearFilterClicked={this.clearFilterClicked}
        />
        <SuggestionBox
          value={this.state.suggestionText}
          suggestionDidChange={this.suggestionTextDidChange}
          onSuggestionSubmit={this.onSuggestionSubmit}
        />
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
