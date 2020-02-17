# If a default host is specifically defined then it's used otherwise the app is
# assumed to be a Heroku review app. Note that `Hash#fetch` is used defensively
# so the app will blow up at boot-time if both `DEFAULT_URL_HOST` and
# `HEROKU_APP_NAME` aren't defined.
if Rails.env == "production"
  host = ENV["HOST_NAME"] ||
    "#{ENV.fetch('HEROKU_APP_NAME')}.herokuapp.com"

  Rails.application.routes.default_url_options.merge!(
    host: host,
    protocol: protocol,
  )
end
