namespace :paperclip do
  desc 'Fix content types'
  # starten als: 'bundle exec rake paperclip:fix_content_types RAILS_ENV=production'
  task :fix_content_types => :environment do
     Category.all.each do |category|
       if category.photo_file_name
         category.photo_content_type = MIME::Types.type_for(category.photo_file_name).first.content_type
         if category.save
           print "C"
         else
           puts "\nFAILURE: Category " + category.errors.first.to_s
         end
       end
     end

     ContentElement.all.each do |content_element|
       if content_element.photo_file_name
         content_element.photo_content_type = MIME::Types.type_for(content_element.photo_file_name).first.content_type
         if content_element.save
           print "E"
         else
           puts "\nFAILURE: Content Element " + content_element.errors.first.to_s
         end
       end
       if content_element.document_file_name
         content_element.document_content_type = MIME::Types.type_for(content_element.document_file_name).first.content_type
         if content_element.save
           print "E"
         else
           puts "\nFAILURE: Content Element " + content_element.errors.first.to_s
         end
       end
     end

    Product.all.each do |product|
      if product.photo_file_name
        product.photo_content_type = MIME::Types.type_for(product.photo_file_name).first.content_type
        if product.save
          print "P"
        else
          puts "\nFAILURE: Product " + product.errors.first.to_s
        end
      end
    end
  end
end
