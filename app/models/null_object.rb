require 'naught'
NullObject = Naught.build do |config|
  config.black_hole
  config.predicates_return false # e.g. any?
end
