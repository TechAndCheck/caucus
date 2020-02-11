# frozen_string_literal: true

Figaro.require_keys(
  "RAILS_ENV",
  "SECRET_KEY_BASE",
  "FACT_STREAM_BASE_URI"
)
