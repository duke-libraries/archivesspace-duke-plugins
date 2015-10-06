Rails.application.config.after_initialize do

  # check configuration
  if AppConfig.has_key?(:user_defined_in_basic)
    AppConfig[:user_defined_in_basic].each do |keys, fields|
      if fields.respond_to?(:each)
        fields.each do |field|
          unless JSONModel(:user_defined).schema['properties'].include?(field)
            $stderr.puts "WARNING: user_defined_in_basic plugin configuration includes " +
              "a field (#{fields}) in the list for #{keys} which is not a user_defined field. " +
              "That's ok, we're just concerned you might have intended to refer to an actual field."
          end
        end
      end
    end
    AppConfig[:user_defined_in_basic]['hide_user_defined_section'] ||= false
  else
    $stderr.puts "WARNING: user_defined_in_basic plugin is active but not configured. " +
      "That's ok, it just won't do anything."
  end

end
