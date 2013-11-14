require 'spec_helper'

describe Categorization do
  it {should belong_to(:product)}
  it {should belong_to(:category)}
end
