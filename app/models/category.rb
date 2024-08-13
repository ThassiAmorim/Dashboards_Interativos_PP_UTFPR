class Category < ApplicationRecord
  self.table_name = 'categories'
  self.primary_key = 'id'

  has_many :work_packages, foreign_key: 'category_id'
end
