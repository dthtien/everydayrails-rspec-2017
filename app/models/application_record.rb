class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.to_csv(records = nil)
    attributes = column_names
    records = all if records.nil?
    CSV.generate(headers: true) do |csv|
      csv << attributes

      records.each do |record|
        csv << attributes.map { |attr| record.send attr }
      end
    end
  end
end
