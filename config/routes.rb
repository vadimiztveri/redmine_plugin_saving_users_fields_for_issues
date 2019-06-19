get 'issues/:issue_id/subtask_list_columns', :to => 'subtask_list_columns#edit'
put 'issues/:issue_id/subtask_list_columns', :to => 'subtask_list_columns#update'
post 'issues/:issue_id/subtask_list_columns/', :to => 'subtask_list_columns#create'
delete 'issues/:issue_id/subtask_list_columns/:id', :to => 'subtask_list_columns#destroy'
