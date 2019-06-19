module SubtaskListColumns::Patches
  module ProjectPatch
    def self.included(base)
      base.class_eval do
        has_many :subtask_list_columns, class_name: SubtaskListColumn, dependent: :destroy, inverse_of: :project
      end
    end
  end
end
