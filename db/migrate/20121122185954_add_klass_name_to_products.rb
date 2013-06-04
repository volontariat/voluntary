class AddKlassNameToProducts < ActiveRecord::Migration
  def up
    Product.each do |product|
      next if product.klass_name.present?
      
      if product.name == 'Product'
        product.klass_name = 'Product'
      else
        product.klass_name = [
          'Product', name.gsub(' - ', '_').gsub('-', '_').gsub(' ', '_').classify
        ].join('::')
      end
      
      product.save!
    end
  end
end