require 'spec_helper'

describe Contracting::ProductsController, :type => :controller do

  describe "grid index" do
    it "returns the correct json for all users" do
      create(:product_with_inventory)
      create(:second_product)
      no_redirects and act_as_sales

      get :grid_index
      expect(response.body).to be_json_eql({ records: [ { alternative_number: "alternative 123",
                                                          description_de: "Deutsch: Lorem ipsum dolor sit amet, consectetur adipisicing elit. Ullam, aliquid.",
                                                          description_en: "English: Lorem ipsum dolor sit amet, consectetur adipisicing elit. Similique, repellat!",
                                                          not_shippable: nil,
                                                          number: "product_with_inventory",
                                                          recid: 1,
                                                          title_de: "default product",
                                                          title_en: "Article One Two Three",
                                                          warranty_de: "Ein Jahr mit gewissen Einschränkungen",
                                                          warranty_en: "One year with evereal restrictions" },
                                                        { alternative_number: nil,
                                                          description_de: "Deutsch: Noch ein Text.",
                                                          description_en: "English: Another Text!",
                                                          not_shippable: nil,
                                                          number: "42",
                                                          recid: 2,
                                                          title_de: "Artikel Zwei",
                                                          title_en: "Article Two",
                                                          warranty_de: "Ein Monat mit gewissen Einschränkungen",
                                                          warranty_en: "One month with evereal restrictions"}
                                                      ],
                                             status: "success",
                                             total: 2 }.to_json)
    end
  end
end