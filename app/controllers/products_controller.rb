class ProductsController < ApplicationController

  hobo_model_controller
  auto_actions :show, :lifecycle
  index_action :comparison

  def do_add_to_basket
    do_transition_action :add_to_basket do
      flash[:success] = "Das Produkt wurde zum Warenkorb hinzugefügt."
      flash[:notice] = nil
      redirect_to session[:return_to]
    end
  end

  def do_compare
    do_transition_action :compare do
      session[:compared] << this.id
      flash[:success] = "Das Produkt wurde zur Vergleichsliste hinzugefügt."
      flash[:notice] = nil
      redirect_to session[:return_to]
    end
  end

  def do_dont_compare
    do_transition_action :dont_compare do
      session[:compared].delete(this.id)
      flash[:success] = "Das Produkt wurde aus der Vergleichsliste entfernt."
      flash[:notice] = nil
      redirect_to session[:return_to]
    end
  end

  Propertyline = Struct.new(:property_group_position,
                            :property_position,
                            :group_id,
                            :name,
                            :values,
                            :isgroup)

  def comparison
    self.this = Product.where(id: session[:compared]).paginate(:page => 1, :per_page => Product.count)

    @property_lines = Array.new()
    this.each_with_index do |product, i|
      @i = i
      product.property_groups.each do |property_group|
        if @property_line = @property_lines.find { |e| e[:name] == property_group.name }
          @group_id = @property_line.group_id
        else
          @property_lines << Propertyline.new(property_group.position || 1000,
                                              -1,
                                              property_group.id,
                                              property_group.name,
                                              Array.new(this.count),
                                              true)
          @group_id = property_group.id
        end

        property_group.properties.each do |property|
          @value = property.description ? property.description : property.value + " " + property.unit
          if @property_line = @property_lines.find { |e| e[:name] == property.name &&
                                                         e[:group_id] == @group_id &&
                                                         e[:isgroup] == false }
            @property_line.values[i] = @value
          else
            @property_line = Propertyline.new(property_group.position || 1000,
                                              property.position || 1000,
                                              @group_id,
                                              property.name,
                                              Array.new(this.count),
                                              false)
            @property_line.values[i] = @value
            @property_lines << @property_line
          end
        end
      end

      @property_lines.sort do |a,b|
        comparison = (a.property_group_position <=> b.property_group_position)
        comparison.zero? ? (a.property_position <=> b.property_position) : comparison
      end
    end

    hobo_index
  end

end