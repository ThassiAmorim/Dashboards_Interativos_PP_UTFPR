class User < ApplicationRecord
  self.table_name = 'users'
  self.primary_key = 'id'

  has_many :work_packages, foreign_key: 'responsible_id'
end
