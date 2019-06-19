require 'redmine'

Redmine::Plugin.register :subtask_list_columns do
  name 'Subtask list columns plugin'
  author 'Irina Liber, Vadim Galkin'
  description 'Customize columns in list of subtasks on issue page'
  version '0.0.3'

  permission :manage_project_workflow, {}, :require => :member

  settings  partial: 'settings/subtask_list_columns',
            default:  {
                        'issue_subtasks_sorting_enabled' => false,
                        'place_for_empty_start_dates' => 'after',
                        'redmine_fields' => {
                          'subject' => true,
                          'start_date' => true,
                          'due_date' => true,
                          'assigned_to' => true
                        },
                        'issue_custom_fields' => {
                          '30' => true
                        }
                      }

end

require_dependency 'subtask_list_columns_lib'

Rails.configuration.to_prepare do
  unless IssuesHelper.included_modules.include?(SubtaskListColumnsLib)
    IssuesHelper.send(:include, SubtaskListColumnsLib)
  end

  unless Project.included_modules.include?(SubtaskListColumns::Patches::ProjectPatch)
    Project.send(:include, SubtaskListColumns::Patches::ProjectPatch)
  end

  unless User.included_modules.include?(SubtaskListColumns::Patches::UserPatch)
    User.send(:include, SubtaskListColumns::Patches::UserPatch)
  end
end
