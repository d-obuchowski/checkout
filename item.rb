class Item
  attr_accessor :product_code, :name, :price

  def initialize(product_code, name, price)
    @product_code= product_code
    @name = name
    @price = price.to_s
  end
end

