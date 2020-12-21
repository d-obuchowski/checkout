class Checkout

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
      case prom
      when "spending_over_$60"
        total_price_with_promotions-= calculate_reduced_price_over_60_promo(total_price_with_promotions)
      when "purchasing_red_scarf"
        total_price_with_promotions-= calculate_reduced_price_red_scarf_promo(total_price_with_promotions)
      end
    end

    total_price_with_promotions
  end

  def calculate_reduced_price_red_scarf_promo(total_price_with_promotions)
    return 0 unless scarf_items_size >= 2

    scarf_items_size * BigDecimal(scarf_regular_price - scarf_promotion_price)
  end

  def calculate_reduced_price_over_60_promo(total_price_with_promotions)
    return 0 unless total_price_with_promotions > 60

    total_price_with_promotions * BigDecimal("0.10")
  end

  def scarf_regular_price
    scarf_price = @items.find { |item| item.product_code == "001" }.price
    BigDecimal(scarf_price)
  end

  def scarf_promotion_price
    BigDecimal("8.50")
  end

  def scarf_items_size
    @items.count { |item| item.product_code == "001" }
  end
end

