import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['limitInputForm', 'textBox', 'submitLink']

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
    const submitUrl = '/admin/claims/export.csv'
    const limit = parseInt(this.textBoxTarget.value, 10)
    if (this.textBoxTarget.value.length > 0 && (Number.isNaN(limit))) {
      alert('WARNING: Only whole numbers are allowed, or really even make sense.')
      return
    }
    this.submitLinkTarget.href = `${submitUrl}?minimum_categories=${limit}`
  }
}
