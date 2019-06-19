subtaskListColumns = function() {
  var self = this,
      $addColumnBottons = $(".add-column-botton"),
      issueId = $('#issue').attr('dataissueid'),
      columnLink = '/issues/' + issueId + '/subtask_list_columns/',
      $persistedFields = $('#persisted_fields'),
      $avalibleFields = $('#avalible_fields'),
      $deleteColumnBotton = $('.delete-column-botton');

  $addColumnBottons.click(function(event) {
    self.addColumn(event);
  });

  addColumn = function(event) {
    var columnKey = $(event.target).attr('columnkey');
    self.add_column(columnKey);
  }

  $deleteColumnBotton.click(function(event) {
    self.deleteColumn(event);
  });

  deleteColumn = function(event) {
    var $target = $(event.target),
        id = $target.attr('subtask_list_column_id'),
        linkToDelete = columnLink + id;

    $.ajax({
      url: linkToDelete,
      type: 'DELETE',
      success: function(data) {
        if (data.status == 'ok') {
          var issueField = data.issue_field,
              name = data.name;

          removeRowFromTable($target);
          addRowToAll(issueField, name);
        } else {
          console.log(data.error);
        }
      }
    });
  };

  add_column = function(columnKey) {
    var $parent = $('#' + columnKey + ''),
        $loader = $parent.find('.loader img');

    $loader.show();

    data = {
      issue_id: issueId,
      issue_field: columnKey,
      field_type: 'redmine'
    };

    $.ajax({
      url: columnLink,
      type: 'POST',
      data: data
    }).done(function(data){
      $loader.hide();

      if (data.status == 'ok') {
        addRowToTable(data.subtask_list_column, data.name);
        deleteRowFromAll(columnKey);
      } else {
        console.log(data.error);
      }
    });
  };

  addRowToTable = function(subtask_list_column, name) {
    var row = "<tr class='persisted-row'>";
    row += "<td class='position'><span class='text'>" + subtask_list_column.position + '</span></td>';
    row += "<input type='hidden' name='subtask_list_column[" + subtask_list_column.id + "]' id='subtask_list_column_" + subtask_list_column.id + "' value='" + subtask_list_column.position + "' class='position-hidden-field' >"
    row += "<td><span class='text'>" + name + '</span></td>';
    row += "<td class='delete-column'><span class='delete-column-botton' subtask_list_column_id='" + subtask_list_column.id + "'>Удалить</span></td>";
    row += '<td class="td-button"><span class="button move">↕</span></td>';
    row += '</tr>';

    $persistedFields.append(row);
  };

  deleteRowFromAll = function(columnKey) {
    var $row = $("#" + columnKey);
    $row.remove();
  };

  removeRowFromTable = function($target) {
    var $row = $target.parents('.persisted-row');
    $row.remove();
  };

  addRowToAll = function(issueField, name) {
    var row = '<tr id=' + issueField + "><td><span class='text'>" + name + '</span></td>';
    row += "<td class='add-column'><span class='add-column-botton' columnkey='" + issueField + "'>Добавить</span></td>";
    row += "<td class='loader'><img src='/images/loader.gif'></td>";
    row += '</tr>';

    $avalibleFields.append(row);
  };
};

$(document).ready(subtaskListColumns());
