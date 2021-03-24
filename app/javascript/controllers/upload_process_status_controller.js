import { Controller } from 'stimulus'
import consumer from '../channels/consumer'

export default class extends Controller {
  static targets = ['progress', 'submitButton']

  connect = () => {
    this.progressTarget.value = ''
    this.submitButtonTarget.disabled = false
    this.submitButtonTarget.value = 'Save'
  }

  onPostSuccess = (event) => {
    const [data, status, xhr] = event.detail
    const { jobId } = JSON.parse(xhr.response)

    this.submitButtonTarget.disabled = true
    this.submitButtonTarget.value = 'Loading...'

    this.channel = consumer.subscriptions.create(
      { channel: 'ImportClaimsChannel', importId: jobId },
      {
        connected: this._cableConnected.bind(this),
        disconnected: this._cableDisconnected.bind(this),
        received: this._cableReceived.bind(this),
      },
    )
  }

  onPostStart = (event) => {
    this.submitButtonTarget.disabled = true
    this.submitButtonTarget.value = 'Uploading...'
  }

  _cableConnected = () => {
    console.log('Connected')
    this.progressTarget.value = 'Prepping...'
    this.submitButtonTarget.disabled = true
    this.submitButtonTarget.value = 'Loading...'
  }

  _cableDisconnected = () => {
    console.log('Disconnected')
    // Called when the subscription has been terminated by the server
  }

  _cableReceived = (data) => {
    // Called when there's incoming data on the websocket for this channel
    console.log(`Date Received: ${data}`)
    const { total, completed } = data
    this.progressTarget.value = `${completed} / ${total} : ${((completed / total) * 100).toFixed(1)}%`

    if (completed != total) {
      this.submitButtonTarget.disabled = true
      this.submitButtonTarget.value = 'Loading...'
    } else {
      this.submitButtonTarget.value = 'Completed!'
    }
  }
}
