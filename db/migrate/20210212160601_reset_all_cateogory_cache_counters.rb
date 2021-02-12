class ResetAllCateogoryCacheCounters < ActiveRecord::Migration[6.0]
  def up
    Category.all.each do |category|
      category.update_claims_count(true)
    end
  end

  def down
  end
end
