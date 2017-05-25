class Phone < ActiveRecord::Base
  belongs_to :resource, touch: true
end
