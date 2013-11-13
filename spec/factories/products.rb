FactoryGirl.define do
  factory :product do
    name_de        "Artikel Eins Zwei Drei"
    name_en        "Article One Two Three"
    number         123
    description_de "Deutsch: Lorem ipsum dolor sit amet, consectetur adipisicing elit. Ullam, aliquid."
    description_en "English: Lorem ipsum dolor sit amet, consectetur adipisicing elit. Similique, repellat!"
  end
end
