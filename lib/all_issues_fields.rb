class AllIssuesFields
  def self.redmine_fields
    [
      { field: :id, name: 'ID', type: :string },
      { field: :tracker, name: 'Трекер', type: :name_association },
      { field: :project, name: 'Проект', type: :link_to_project },
      { field: :subject, name: 'Тема', type: :string },
      { field: :description, name: 'Описание', type: :string },
      { field: :start_date, name: 'Дата начала', type: :date },
      { field: :due_date, name: 'Дата завершения', type: :date },
      { field: :category, name: 'Категория', type: :name_association },
      { field: :status, name: 'Статус', type: :string },
      { field: :assigned_to, name: 'Исполнитель', type: :link_to_user },
      { field: :priority, name: 'Приоритет', type: :name_association },
      { field: :fixed_version, name: 'Версия', type: :name_association },
      { field: :author, name: 'Автор', type: :link_to_user },
      { field: :lock_version, name: 'Версия', type: :string },
      { field: :created_on, name: 'Создана (дата)', type: :date },
      { field: :updated_on, name: 'Обновлена (дата)', type: :date },
      { field: :estimated_hours, name: 'Запланированное время на выполнение (в часах)', type: :string },
      { field: :parent, name: 'Рорительская задача', type: :link_to_issue },
      { field: :root, name: 'Корневая задача', type: :link_to_issue },
      { field: :is_private, name: 'Приватная', type: :boolean },
      { field: :closed_on, name: 'Закрыта (дата)', type: :date }
    ]
  end

  def self.custom_fields
    IssueCustomField.all.map do |custom_field|
      {
        id: custom_field.id,
        name: custom_field.name
      }
    end
  end

  def self.name_from_field
    name_from_field = {}

    redmine_fields.each do |redmine_field|
      name_from_field[redmine_field[:field]] = redmine_field[:name]
    end

    name_from_field
  end
end
