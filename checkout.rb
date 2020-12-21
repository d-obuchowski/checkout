require "bigdecimal"

class Checkout

  SCARF_REGULAR_PRICE = BigDecimal("9.25")
  SCARF_PROMOTION_PRICE = BigDecimal("8.50")
  SCARF_CODE = "001"
  PRODUCT_PROMOTIONAL_RULES = ["purchasing_red_scarf"]

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
    "%.2f" % total_price_with_promotions_for_entire_cart
  end

  private

  attr_reader :promotional_rules

  def set_price(item)
    if item.product_code == SCARF_CODE && scarf_promotion_detected?
      # if we calculate promotion for the second scarf, we also should calculate promotion for first scarf
      # we added first scarf for regular price, but we should calculate scarf price by promotion
      scarf_items_size == 2 ? SCARF_PROMOTION_PRICE - (SCARF_REGULAR_PRICE - SCARF_PROMOTION_PRICE) : SCARF_PROMOTION_PRICE
    else
      BigDecimal(item.price)
    end
  end

  def scarf_promotion_detected?
    scarf_items_size >= 2 && promotional_rules.include?("purchasing_red_scarf")
  end

  def total_price_with_promotions_for_entire_cart
    total_price_with_promotions = @total_price

    promotions_for_entire_shopping_cart.each do |prom|
      total_price_with_promotions-= self.send("calculate_reduced_price_#{prom}_prom", total_price_with_promotions)
    end

    total_price_with_promotions
  end

  def promotions_for_entire_shopping_cart
    @promotions_for_entire_shopping_cart ||= promotional_rules.reject { |rule| PRODUCT_PROMOTIONAL_RULES.include?(rule) }
  end

  def calculate_reduced_price_spending_over_60_prom(total_price_with_promotions)
    return 0 unless total_price_with_promotions > 60

    total_price_with_promotions * BigDecimal("0.10")
  end

  def scarf_items_size
    @items.count { |item| item.product_code == "001" }
  end
end
