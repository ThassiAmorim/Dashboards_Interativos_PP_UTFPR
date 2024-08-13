class WorkPackage < ApplicationRecord
  self.table_name = 'work_packages'
  self.primary_key = 'id'

  # Associação para responsável
  belongs_to :responsible_user, class_name: 'User', foreign_key: 'responsible_id', optional: true
  # Associação para as tuplas filhas
  has_many :children, class_name: "WorkPackage", foreign_key: "parent_id"

  # Associacao para categorias:
  belongs_to :category, class_name: 'Category', foreign_key: 'category_id', optional: true

  # Definindo o escopo padrão para filtrar por project_id
  default_scope { where(project_id: 8).where(type_id: [8, 9]) }
end
