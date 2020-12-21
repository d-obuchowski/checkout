require "bigdecimal"

class Checkout

  SCARF_REGULAR_PRICE = BigDecimal("9.25")
  SCARF_PROMOTION_PRICE = BigDecimal("8.50")

  def initialize(promotional_rules)
    @total_price = BigDecimal(0)
    @items= []
    @promotional_rules = promotional_rules
  end

  def scan(item)
    @items << item
    @total_price += set_price(item)
  end

  def total
    "%.2f" % calculate_total_price_with_promotions
  end

  private

  attr_reader :promotional_rules

  def set_price(item)
    BigDecimal(item.price)
  end

  def calculate_total_price_with_promotions
    total_price_with_promotions = @total_price

    promotional_rules.each do |prom|
      total_price_with_promotions-= self.send("calculate_reduced_price_#{prom}_prom", total_price_with_promotions)
    end

    total_price_with_promotions
  end

  def calculate_reduced_price_spending_over_60_prom(total_price_with_promotions)
    return 0 unless total_price_with_promotions > 60

    total_price_with_promotions * BigDecimal("0.10")
  end

  def calculate_reduced_price_purchasing_red_scarf_prom(total_price_with_promotions)
    return 0 unless scarf_items_size >= 2

    scarf_items_size * BigDecimal(SCARF_REGULAR_PRICE - SCARF_PROMOTION_PRICE)
  end

  def scarf_items_size
    @items.count { |item| item.product_code == "001" }
  end
end
