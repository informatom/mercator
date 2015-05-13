FactoryGirl.define do

  factory :content_element do
    folder
    name_de    "Ich bin der deutsche Titel"
    name_en    "I am the english title"
    content_de "Ich bin der deutsche Inhalt"
    content_en "I am the English content"
    markup     "html"
    legacy_id  10
    photo      { fixture_file_upload(Rails.root.to_s + '/spec/support/dummy_image.jpg', 'image/jpg') }
    document   { fixture_file_upload(Rails.root.to_s + '/spec/support/dummy_document.pdf', 'application/pdf') }

    factory :content_element_2 do
      name_de    "2. Titel"
    end

    factory :content_element_3 do
      name_de    "3. Titel"
    end

    factory :content_element_4 do
      name_de    "4. Titel"
    end

    factory :content_element_5 do
      name_de    "5. Titel"
    end

    factory :content_element_6 do
      name_de    "6. Titel"
    end

    factory :content_element_empty do
      name_de    "Titel (leerer Inhalt)"
      content_de nil
      content_en nil
    end

    factory :content_element_with_html do
      content_en <<END_HEREDOC

some <h1>Level one heading in html</h1>

h2. Level two heading in textile

### Level thraee heading in markdown

END_HEREDOC

      factory :content_element_with_textile do
        markup "textile"
      end

      factory :content_element_with_markdown do
        markup "markdown"
      end
    end

    factory :content_element_with_photo_tag do
      name "photo_name"
      content_en '<photo name="photo_name"/>'
    end

    factory :content_element_with_document_tag do
      name "document_name"
      content_en '<document name="document_name"/>'
    end
  end
end