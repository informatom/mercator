FactoryGirl.define do

  factory :comment do
    user
    blogpost
    podcast
    content  "I am a comment"
    ancestry nil

    factory :long_comment do
      content "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod" +
              "tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero" +
              "eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea" +
              "takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet," +
              " consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et" +
              " dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo" +
              " dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem" +
              " ipsum dolor sit amet."
    end
  end
end