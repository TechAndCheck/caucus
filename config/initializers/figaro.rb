# frozen_string_literal: true

Figaro.require_keys(
  "RAILS_ENV",
  "SECRET_KEY_BASE",
  "FACT_STREAM_BASE_URI",
  "MAILGUN_API_KEY",
  "AWS_ACCESS_KEY_ID",
  "AWS_SECRET_ACCESS_KEY",
  "AWS_REGION"
)
