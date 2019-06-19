class SelectedIssueFields
  def self.titles
    title = '<thead><tr><th>'

    if Setting.plugin_subtask_list_columns['issue_subtasks_sorting_enabled']
      titles_redmine_fields = redmine_fields_data.map{ |redmine_field| redmine_field[:name] }
      titles_custom_fields = custom_fields_data.map{ |custom_field| custom_field[:name] }

      # title << '№</th><th>'

      title << (titles_redmine_fields + titles_custom_fields).join('</th><th>')
    else
      title << ['Тема', 'Статус', 'Дата начала', 'Дата завершения', 'Исполнитель', 'Готовность'].join('</th><th>')
    end

    title << '</th></tr></thead>'
    title
  end

  def self.redmine_fields_data
    redmine_fields = Setting.plugin_subtask_list_columns['redmine_fields']&.map{ |key, value| key } || []
    redmine_fields_data = []

    AllIssuesFields.redmine_fields.each do |redmine_field|
      if redmine_fields.include?(redmine_field[:field].to_s)
        redmine_fields_data << redmine_field
      end
    end

    redmine_fields_data
  end

  def self.custom_fields_data
    custom_fields = Setting.plugin_subtask_list_columns['issue_custom_fields']&.map{ |key, value| key } || []
    custom_fields_data = []

    AllIssuesFields.custom_fields.each do |custom_field|
      if custom_fields.include?(custom_field[:id].to_s)
        custom_fields_data << custom_field
      end
    end

    custom_fields_data
  end
end
