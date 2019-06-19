class SubtaskListColumn < ActiveRecord::Base
  FIELD_TYPES = %w(redmine custom)

  belongs_to :project, class_name: Project
  belongs_to :user, class_name: User

  validates :project_id, presence: true
  validates :user_id, presence: true
  validates :issue_field, presence: true
  validates :field_type, presence: true
  validates_inclusion_of :field_type, :in => FIELD_TYPES

  FIELD_TYPES.each do |field_type|
    scope field_type.to_sym, -> { where(field_type: field_type) }
  end

  scope :ordered_by_position, -> { order(position: :asc)}
end
