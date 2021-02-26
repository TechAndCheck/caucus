import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['limitInputForm', 'textBox', 'checkBox', 'articleOnlyCheckBox', 'submitLink']

  static values = { formState: String }

  initialize = () => {
    this.formState = 'closed'
  }

  toggleForm = () => {
    switch (this.formState) {
      case 'closed':
        this.limitInputFormTarget.classList.add('open')
        this.formState = 'open'
        break
      case 'open':
        this.limitInputFormTarget.classList.remove('open')
        this.formState = 'closed'
        break
      default:
        // Do nothing
    }
  }

  formUpdated = (event) => {
    event.preventDefault()
    const submitUrl = '/admin/claims/export.csv'
    let limit = parseInt(this.textBoxTarget.value, 10)
    // Check if a number has been typed
    if (Number.isNaN(limit)) {
      // If it's not a number, but something is typed, error out.
      if (this.textBoxTarget.value.length > 0) {
        alert('WARNING: Only whole numbers are allowed, or really even make sense.')
        return
      }

      // We default to a limit of 0 if the field is blank
      limit = 0
    }

    this.submitLinkTarget.href = `${submitUrl}?minimum_categories=${limit}&include_totals=${this.checkBoxTarget.checked}&only_articles=${this.articleOnlyCheckBoxTarget.checked}`
  }
}
