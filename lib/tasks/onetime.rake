# frozen_string_literal: true

# Tasks that should be run once to alter data in production.

namespace :onetime do
  # Add new categories.
  #
  # This is idempotent so it is safe to run more than once
  task add_new_categories: :environment do
    Category.transaction do
      categories = [
        'Family Shelters',
        'Domestic Violence Shelters',
        'Advocacy & Legal Aid',
        'Eviction Defense',
        'Housing/Tenants Rights',
        'Youth',
        'Seniors',
        'End of Life Care',
        'Home Delivered Meals',
        'Senior Centers',
        'Congregate Meals',
        'Housing Rights',
        'Eviction Defense',
        'Domestic Violence',
        'Legal Representation',
        'Prison/Jail Related Services',
        'Legal Services',
        'Domestic Violence',
        'Domestic Violence Shelters',
        'Domestic Violence Hotlines',
        'Legal Representation',
        'Prison/Jail Related Services',
        'Re-entry Services',
        'Clean Slate',
        'Probation and Parole',
        'Legal Services'
      ]
      categories.each do |c|
        Category.find_or_create_by(name: c)
      end
    end
  end
end
