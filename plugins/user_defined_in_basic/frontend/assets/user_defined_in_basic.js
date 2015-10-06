function UserDefinedInBasic() {
}

UserDefinedInBasic.prototype.init = function(fields, read_only_view, hide_user_defined_section) {
    var bi = $("#basic_information");

    if (bi.length == 0) {
        // Section not visible yet (e.g. on a Resource edit page).  We'll try
        // again when the event fires.
        return false;
    }

    // add user defined if necessary, and disable remove button
    var user_defined_section = $('section.subrecord-form[data-object-name="user_defined"]');
    var remove_btn = user_defined_section.find('.subrecord-form-remove');
    if (remove_btn.length == 0) {
        user_defined_section.find('.btn-default').filter(':visible').click();
        window.scrollTo(0,0);
    }

    // hide the remains of the user defined section if configured thus
    if (hide_user_defined_section) {
	$('section[id$=_user_defined_]').hide();
	$('li[class^=sidebar-entry][class$=user_defined_]').hide();
    } else {
	if (!read_only_view) {
	    // if we're not hiding then disable the remove button
	    user_defined_section.find('.subrecord-form-remove').attr('disabled', 'disabled');
	}
    }

    fields.map(function (field) {
        // Find our fields of interest by their label text
        var fld_lab = $('.control-label').filter(function() { return $(this).text() === field });

        if (fld_lab.length > 0) {
            if (read_only_view) {
                var elt_to_move = fld_lab.addClass('col-sm-2').removeClass('col-md-3').parent();
                elt_to_move.insertBefore(bi.find("div.audit-display-wide"));
            } else {
                var elt_to_move = fld_lab.parent();
                if (bi.find("fieldset").length > 0) {
                    elt_to_move.appendTo(bi.find("fieldset"));
                } else {
                    elt_to_move.appendTo(bi);
                }
            }
        }
    });
};
