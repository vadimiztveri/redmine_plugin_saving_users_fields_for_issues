sortable = function() {
  var self = this,
      $persistedFields = $('#persisted_fields');

  $persistedFields
    .sortable({
      axis: "y",
      handle: "span.button.move",
      stop: function() {
        recountPositions();
      }
    });

  recountPositions = function() {
    var $updated_table = $('#persisted_fields'),
        $rows = $updated_table.find('.persisted-row'),
        count = $rows.size();

    $rows.each(function (index) {
      var $position = $(this).find('.position .text'),
          $positionHiddenField = $(this).find('.position-hidden-field');

      $position.text(index + 1);
      $positionHiddenField.val(index + 1);
    });
  };
};

$(document).ready(sortable());
