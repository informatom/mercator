require 'spec_helper'

describe Webpage do
  it "is valid with title_de, title_en, url, position, page_template" do
    expect(build :webpage).to be_valid
  end

  it {should validate_presence_of :title_de}
  it {should validate_presence_of :position}

  it {should validate_numericality_of :position}

  it {is_expected.to respond_to :name}

  it {should belong_to :page_template}
  it {should validate_presence_of :page_template}

  it {should have_many :page_content_element_assignments}
  it {should have_many :content_elements}

  it "is versioned" do
    is_expected.to respond_to :versions
  end

  it "is in a tree structure" do
    is_expected.to respond_to :parent
    is_expected.to respond_to :children
  end


  #--- Instance Methods ---#


  context "menu" do
    it "returns true if state is published and there is at least one published child" do
      @page_template = create(:page_template)
      @webpage = create(:webpage, state: "published",
                                  page_template: @page_template)
      @child_webpage = create(:webpage, title_de: "Child page",
                                        state: "published",
                                        parent: @webpage,
                                        page_template: @page_template)
      expect(@webpage.menu).to eql true
    end

    it "returns false if there is no published child" do
      @webpage = create(:webpage, state: "published")
      expect(@webpage.menu).to eql false
    end
  end


  context "content_element" do
    it "finds assigned content element by used as" do
      @webpage = create(:webpage)
      @content_element = create(:content_element)
      create(:page_content_element_assignment, webpage: @webpage,
                                               content_element: @content_element,
                                               used_as: "page_title" )
      expect(@webpage.content_element("page_title")).to eql @content_element
    end

    it "finds content element also by gemman name" do
      @webpage = create(:webpage)
      @content_element = create(:content_element, name_de: "Deutscher Titel")
      expect(@webpage.content_element("Deutscher Titel")).to eql @content_element
    end

    it "finds content element also by english name" do
      @webpage = create(:webpage)
      @content_element = create(:content_element, name_en: "Some English Title")
      expect(@webpage.content_element("Some English Title")).to eql @content_element
    end
  end


  context "content_element_name" do
    it "returns the content element name" do
      @webpage = create(:webpage)
      @content_element = create(:content_element, name_de: "Deutscher Titel")
      expect(@webpage.content_element_name("Deutscher Titel")).to eql "I am the english title"
    end

    it "returns nil if element not found" do
      @webpage = create(:webpage)
      expect(@webpage.content_element_name("nicht existent")).to eql nil
    end
  end


  context "add_missing_page_content_element_assignments", focus: true do
    pending "pending"
  end


  context "delete_orphaned_page_content_element_assignments" do
    it "deletes content element assignment without entry in placholder list of page template" do
      @webpage = create(:webpage)
      @content_element = create(:content_element)
      create(:page_content_element_assignment, webpage: @webpage,
                                               content_element: @content_element,
                                               used_as: "page_title" )
      expect{@webpage.delete_orphaned_page_content_element_assignments}.to change{PageContentElementAssignment.count}.by -1
    end

    it "leaves content element assignment alone with entry in placholder list" do
      @page_template = create(:page_template)
      @page_template.placeholder_list.add("page_title")

      @webpage = create(:webpage, page_template: @page_template)
      @content_element = create(:content_element)
      create(:page_content_element_assignment, webpage: @webpage,
                                               content_element: @content_element,
                                               used_as: "page_title" )

      expect{@webpage.delete_orphaned_page_content_element_assignments}.not_to change{PageContentElementAssignment.count}
    end
  end


  context "title_with_status" do
    it "returns title, if status is published" do
      @webpage = create(:webpage, state: "published")
      expect(@webpage.title_with_status).to eql "Titel of a Webpage"
    end

    it "returns title with formatted status, if status is not published" do
      @webpage = create(:webpage)
      expect(@webpage.title_with_status).to eql "Titel of a Webpage <em style='color: green'>draft</em>"
    end
  end


  context "visible_for?"do
    context "normal user" do
      before :each do
        @user = create(:user)
      end

      it "returns true for published webpage" do
        @webpage = create(:webpage, state: "published")
        expect(@webpage.visible_for?(user: @user)).to eql true
      end

      it "returns true for published but hidden webpage" do
        @webpage = create(:webpage, state: "published_but_hidden")
        expect(@webpage.visible_for?(user: @user)).to eql true
      end

      it "returns false for draft webpage" do
        @webpage = create(:webpage, state: "draft")
        expect(@webpage.visible_for?(user: @user)).to eql false
      end
    end

    context "content manager" do
      before :each do
        @content_manager = create(:content_manager)
      end

      it "returns true for published webpage" do
        @webpage = create(:webpage, state: "published")
        expect(@webpage.visible_for?(user: @content_manager)).to eql true
      end

      it "returns true for published but hidden webpage" do
        @webpage = create(:webpage, state: "published_but_hidden")
        expect(@webpage.visible_for?(user: @content_manager)).to eql true
      end

      it "returns false for draft webpage" do
        @webpage = create(:webpage, state: "draft")
        expect(@webpage.visible_for?(user: @content_manager)).to eql true
      end
    end
  end
end