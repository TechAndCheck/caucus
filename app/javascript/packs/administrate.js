// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import { Application } from 'stimulus'
import { definitionsFromContext } from 'stimulus/webpack-helpers'

require('@rails/ujs').start()
require('turbolinks').start()

// The next line you only need if you want ActiveStorage support
require('@rails/activestorage').start()

// The next line you only need if you need channels in administrate
require('channels')

// The next two lines you only need if you want ActionText support
require('trix')
require('@rails/actiontext')

require('../administrate/index')

// Loading Stimulus for the backend
const application = Application.start()
const context = require.context('../controllers', true, /\.js$/)
application.load(definitionsFromContext(context))
