require 'rails_helper'

describe 'Checkout' do
  describe '#total' do
    subject(:price) { checkout.total }
    let(:checkout) { Checkout.new(promo_rules) }
    let(:red_scarf) { Item.new('001', 'Red Scarf', 9.25 )}
    let(:silver_cufflinks) { Item.new('002', 'Silver cufflinks', 45.00 )}
    let(:silk_dress) { Item.new('003', 'Silk Dress', 19.95 )}


    context 'when none promos were passed' do
      let(:promo_rules) { [] }

      context 'when 2 red scarfs, 1 silver cufflinks and 1 silk dress added to cart' do
        before do
          checkout.scan(red_scarf)
          checkout.scan(red_scarf)
          checkout.scan(silver_cufflinks)
          checkout.scan(silk_dress)
        end
        it 'returns sum of items without any promotions' do
          expect(price).to eq("83.45")
        end
      end
    end

    context 'when "spending_over_60" promo passed' do
      let(:promo_rules) { ['spending_over_60'] }

      context 'when 2 red scarfs, 1 silver cufflinks and 1 silk dress added to cart' do
        before do
          checkout.scan(red_scarf)
          checkout.scan(silver_cufflinks)
          checkout.scan(silk_dress)
        end

        it 'should use 10% discount' do
          expect(price).to eq("66.78")
        end
      end

      context 'when 2 red scarfs and 1 silk dress added to cart' do
        before do
          checkout.scan(red_scarf)
          checkout.scan(red_scarf)
          checkout.scan(silk_dress)
        end

        it 'should not use 10% discount' do
          expect(price).to eq("38.45")
        end
      end
    end

    context 'when "purchasing_red_scarf" promo passed' do
      let(:promo_rules) { ['purchasing_red_scarf'] }

      context 'when 2 red scarfs, 1 silver cufflinks and 1 silk dress added to cart' do
        before do
          checkout.scan(red_scarf)
          checkout.scan(silk_dress)
          checkout.scan(red_scarf)
        end

        it 'should decrease price by 8.50' do
          expect(price).to eq("36.95")
        end
      end

      context 'when 1 red scarfs and 1 silk dress added to cart' do
        before do
          checkout.scan(red_scarf)
          checkout.scan(silver_cufflinks)
          checkout.scan(silk_dress)
        end

        it 'should not decrease price by 8.50' do
          expect(price).to eq("74.20")
        end
      end
    end

    context 'when "purchasing_red_scarf" and "spending_over_60" promo passed' do
      let(:promo_rules) { %w[purchasing_red_scarf spending_over_60] }

      context 'when 2 red scarfs, 1 silver cufflinks and 1 silk dress added to cart' do
        before do
          checkout.scan(red_scarf)
          checkout.scan(silver_cufflinks)
          checkout.scan(red_scarf)
          checkout.scan(silk_dress)
        end

        it 'should decrease price by 8.50 and use 10% discount' do
          expect(price).to eq("73.76")
        end
      end
    end

    context 'when "spending_over_60" and "purchasing_red_scarf" promo passed' do
      let(:promo_rules) { %w[spending_over_60  purchasing_red_scarf] }

      context 'when 2 red scarfs, 1 silver cufflinks and 1 silk dress added to cart' do
        before do
          checkout.scan(red_scarf)
          checkout.scan(silver_cufflinks)
          checkout.scan(red_scarf)
          checkout.scan(silk_dress)
        end

        it 'should decrease price by 8.50 and use 10% discount' do
          expect(price).to eq("73.76")
        end
      end
    end
  end
end
