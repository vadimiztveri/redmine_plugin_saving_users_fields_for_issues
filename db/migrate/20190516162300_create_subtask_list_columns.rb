class CreateSubtaskListColumns < ActiveRecord::Migration
  def change
    create_table :subtask_list_columns, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.integer :project_id, null: false
      t.integer :user_id, null: false
      t.string :issue_field, null: false
      t.string :field_type, null: false
      t.integer :position
      t.datetime :created_at
      t.datetime :updated_at
    end
  end

   def down
    drop_table :subtask_list_columns
  end
end
