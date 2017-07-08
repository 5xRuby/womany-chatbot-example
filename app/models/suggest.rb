class Suggest < ApplicationRecord
  def options
    self[:options].split(',')
  end
end
