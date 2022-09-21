class TaxiRequest < ApplicationRecord
  def status_lang
    case self.status
    when 1
      :waiting
    when 2
      :accepted
    when 3
      :canceled
    when 4
      :completed
    end
  end
end
