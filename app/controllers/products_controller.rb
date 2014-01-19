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

  Propertyline = Struct.new(:position, :group, :name, :values, :isgroup)

  def comparison
    self.this = Product.where(id: session[:compared]).paginate(:page => 1, :per_page => Product.count)

    @property_lines = Array.new()
    this.each_with_index do |product, i|
      product.property_groups.each do |pg|
        if @line = @property_lines.find { |e| e[:name] == pg.name }
          @group = @line.group
        else
          @property_lines << Propertyline.new(pg.position, pg.id, pg.name, Array.new(this.count), true)
          @group = pg.id
        end

        pg.properties.each do |p|
          @value = p.description ? p.description : p.value + " " + p.unit
          if @line = @property_lines.find { |e| e[:name] == p.name &&
                                                e[:group] == @group &&
                                                e[:isgroup] == false }
            @line.values[i] = @value
          else
            @line = Propertyline.new(p.position, pg.id, p.name, Array.new(this.count), false)
            @line.values[i] = @value
            @property_lines << @line
          end
        end
      end
    end

    hobo_index
  end

end