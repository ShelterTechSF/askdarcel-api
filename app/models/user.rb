# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id           :integer          not null, primary key
#  name         :string
#  is_superuser :boolean          default(FALSE)
#
class User < ActiveRecord::Base
  has_and_belongs_to_many(:groups,
                          join_table: "user_groups")
end
