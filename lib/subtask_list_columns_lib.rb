require_dependency 'issues_helper'
require 'date'

module SubtaskListColumnsLib
  def self.included(base)
    base.send(:include, InstanceMethods)
    base.class_eval do
      unloadable
      alias_method_chain :render_descendants_tree, :listed

      def build_issue_descendants_tree(issues, issue)
        issues_array = []
        ancestors = issues.select {|i| i.parent_id === issue.id }
        ancestors = sort_issues(ancestors)
        issues_array << issue
        ancestors.each do |item|
          issues_array.concat(build_issue_descendants_tree(issues, item))
        end
        issues_array
      end

      def sort_issues(issues)
        if subtasks_sorting_enabled?
          issues.sort_by{ |issue| issue.start_date || get_empty_start_date }
        else
          issues.sort_by(&:start_date)
        end
      end

      def subtasks_sorting_enabled?
        !!Setting.plugin_subtask_list_columns['issue_subtasks_sorting_enabled']
      end

      def get_empty_start_date
        if Setting.plugin_hot_additions['place_for_empty_start_dates'] == 'before'
          Date.new(1900)
        else
          Date.new(2100)
        end
      end
    end
  end

  module InstanceMethods
    # building descendants tree sorted by start date
    def render_descendants_tree_with_listed(issue)
      sorted_issues = []
      issues = issue.descendants.visible.preload(:status, :priority, :tracker, :assigned_to)
      issues.select {|x| x.parent_id === issue.id}.sort_by(&:start_date).each do |i|
        sorted_issues.concat(build_issue_descendants_tree(issues, i))
      end

      s = '<form><table class="list issues subtask_list_columns">'
      s << SelectedIssueFields.titles

      issue_list(sorted_issues) do |child, level|
        css = "issue issue-#{child.id} hascontextmenu #{child.css_classes}"
        css << " idnt idnt-#{level}" if level > 0

        s << "<tr class='#{css}'>"

        if Setting.plugin_subtask_list_columns['issue_subtasks_sorting_enabled']
          SelectedIssueFields.redmine_fields_data.each do |redmine_field_data|
            s << '<td>'
            s << IssueFieldConvertToFormat.new(child, redmine_field_data[:field], redmine_field_data[:type]).render
            s << '</td>'
          end

          SelectedIssueFields.custom_fields_data.each do |custom_field_data|
            s << '<td>'
            s << GetCustomValue.new(child, custom_field_data[:id]).render
            s << '</td>'
          end
        else
          s << content_tag('td', check_box_tag("ids[]", child.id, false, :id => nil), :class => 'checkbox')
          s << content_tag('td', link_to_issue(child, :project => (issue.project_id != child.project_id)), :class => 'subject', :style => 'width: 50%')
          s << content_tag('td', h(child.status), :class => 'status')

          s << content_tag('td', format_date(child.start_date), :class => 'status')
          s << content_tag('td', format_date(child.due_date), :class => 'status')

          s << content_tag('td', link_to_user(child.assigned_to), :class => 'assigned_to')
          s << content_tag('td', child.disabled_core_fields.include?('done_ratio') ? '' : progress_bar(child.done_ratio), :class=> 'done_ratio')
        end

      end
      s << '</tr></table></form>'
      s.html_safe
    end
  end
end
