require "administrate/base_dashboard"

class RoleDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    name: Field::String,
  }.freeze

  COLLECTION_ATTRIBUTES = [
    :name,
  ].freeze

  SHOW_PAGE_ATTRIBUTES = [
    :name,
  ].freeze

  FORM_ATTRIBUTES = [
    :name,
  ].freeze

  def display_resource(role)
    "#{role.name}"
  end
end
