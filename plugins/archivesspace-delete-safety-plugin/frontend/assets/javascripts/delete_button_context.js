$(document).ready(function() {

  $.fn.extend({

    updateDeleteButton: function() {

      var updateButton = function() {
        var deleteBtn = $('.record-toolbar .delete-record.initialised');
        if (deleteBtn.length > 0) {
          deleteTarget = $(deleteBtn).attr('data-target');
          if (deleteTarget.match(/resources/)) {
            $(deleteBtn).html('Delete Resource');
          }
          else if (deleteTarget.match(/archival_objects/)) {
            $(deleteBtn).html('Delete Archival Object');
          }
          console.log(deleteTarget);
        }
      }

      $( document ).ajaxComplete(function() {
        updateButton();
      });

    }

  });

  $(document).updateDeleteButton();

});
