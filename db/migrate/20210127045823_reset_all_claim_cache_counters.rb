class ResetAllClaimCacheCounters < ActiveRecord::Migration[6.0]
  def up
    Claim.all.each do |claim|
      claim.update_categories_count(true)
    end
  end

  def down
  end
end
