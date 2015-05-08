FactoryGirl.define do

  factory :podcast do
    number 1
    title       "First Podcast"
    shownotes   "Well, this is an truly awesome episode with some shownotes"
    duration    "00:04:50"
    published_at "2013-08-23 15:32:00"
  end
end