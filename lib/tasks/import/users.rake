def import_users
  puts "\nUsers:"

  Legacy::User.all.each do |legacy_user|
    user = User.find_or_initialize_by_name(legacy_user.name)
    if user.update_attributes(email_address: legacy_user.email,
                              legacy_id: legacy_user.id)
      print "U"
    else
      puts "\nFAILURE: User: " + user.errors.first.to_s
    end
  end
end