require "administrate/base_dashboard"

class ClaimDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    categories: Field::HasMany,
    id: Field::Number,
    statement: Field::String,
    speaker_name: Field::String,
    speaker_title: Field::String,
    date: Field::Date,
    location: Field::String,
    publisher_name: Field::String,
    fact_stream_id: Field::String.with_options(searchable: false),
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    checked: Field::Boolean,
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
  categories
  statement
  speaker_name
  date
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
  id
  statement
  speaker_name
  speaker_title
  date
  location
  publisher_name
  fact_stream_id
  categories
  created_at
  updated_at
  checked
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
  categories
  statement
  speaker_name
  speaker_title
  date
  location
  publisher_name
  fact_stream_id
  checked
  ].freeze

  # COLLECTION_FILTERS
  # a hash that defines filters that can be used while searching via the search
  # field of the dashboard.
  #
  # For example to add an option to search for open resources by typing "open:"
  # in the search field:
  #
  #   COLLECTION_FILTERS = {
  #     open: ->(resources) { resources.where(open: true) }
  #   }.freeze
  COLLECTION_FILTERS = {
    checked: ->(resources) { resources.where(checked: true) }
  }.freeze

  # Overwrite this method to customize how claims are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(claim)
  #   "Claim ##{claim.id}"
  # end
end
