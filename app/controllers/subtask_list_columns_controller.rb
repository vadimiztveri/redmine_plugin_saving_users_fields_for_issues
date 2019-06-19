class SubtaskListColumnsController < ApplicationController
  before_filter :get_issue
  before_filter :get_project
  before_filter :get_fields_names, only: [:edit, :create, :destroy]
  before_filter :get_subtask_list_columns, only: [:edit, :create]

  def edit
    @new_subtask_list_columns = new_subtask_list_columns
  end

  def update
    positions = params[:subtask_list_column]

    positions.each do |id, position|
      SubtaskListColumn.find(id).update_attribute :position, position.to_i
    end

    redirect_to action: :edit
  end

  def create
    position = get_max_position

    subtask_list_column = User.current.subtask_list_columns.build(
      project: @project,
      issue_field: params[:issue_field],
      field_type: params[:field_type],
      position: position
    )

    if subtask_list_column.valid?
      subtask_list_column.save
      json = {
        status: :ok,
        name: @fields_names[subtask_list_column.issue_field.to_sym],
        subtask_list_column: subtask_list_column
      }
    else
      json = {
        status: :error,
        error: subtask_list_column.errors.messages
      }
    end

    render_json(json)
  end

  def destroy
    subtask_list_column = User.current.subtask_list_columns.where(id: params[:id]).take



    if subtask_list_column.present?
      json = {
        status: :ok,
        issue_field: subtask_list_column.issue_field,
        name: @fields_names[subtask_list_column.issue_field.to_sym]
      }

      subtask_list_column.delete
    else
      json = {
        status: :error,
        error: :subtask_list_column_not_defined
      }
    end

    render_json(json)
  end

  private

  def render_json(json)
    render  json: json.to_json,
            status: 200,
            content_type: 'application/json',
            layout: false
  end

  def get_issue
    @issue ||= Issue.find(params[:issue_id])
  end

  def get_project
    @project ||= @issue.project
  end

  def get_subtask_list_columns
    @subtask_list_columns ||= @project
                                .subtask_list_columns
                                .where(user: User.current)
                                .ordered_by_position
  end

  def get_fields_names
    @fields_names ||= AllIssuesFields.name_from_field
  end

  def new_subtask_list_columns
    used_columns = @subtask_list_columns.select{ |column| column.field_type == "redmine" }.map(&:issue_field)
    @fields_names.select{ |key, value| !used_columns.include?(key.to_s) }.map{ |key, value| {key: key, value: value} }
  end

  def get_max_position
    @subtask_list_columns.map(&:position).max + 1
  end
end
