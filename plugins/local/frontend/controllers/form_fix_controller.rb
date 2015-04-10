#
# Add this file to plugins/local/frontend/controllers/form_fix_controller.rb
# Obviously not a controller, but the naming convention is used to make sure that 
# it loads. 
#
module AspaceFormHelper

  class FormContext

    def label_and_date(name, opts = {})
      field_opts = (opts[:field_opts] || {}).merge({
          :class => "date-field form-control",
          :"data-format" => "yyyy-mm-dd",
          :"data-date" => Date.today.strftime('%Y-%m-%d'),
          :"data-autoclose" => true,
          :"data-force-parse" => false
      })

      if obj[name].blank? && opts[:default]
        value = opts[:default]
      else
        value = obj[name]
      end
      
      opts[:col_size] = 4

      date_input = textfield(name, value, field_opts)

      label_with_field(name, date_input, opts)
    end
  end
end
