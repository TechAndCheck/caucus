require "test_helper"

class ClaimTest < ActiveSupport::TestCase
  test "Claim should only have one version of the claim at a time" do
    claim = claims(:two)
    category = categories(:one)

    # First we add a category and save it
    claim.categories << category
    claim.save!
    assert 1, claim.categories.count

    # Then we add the same category, and made sure it's there, but not saved yet
    claim.categories << category
    assert 2, claim.categories.count

    # Then we save, and check again
    claim.save!
    assert 1, claim.categories.count
  end

  test "Claim should validate uniqueness of fact_stream_id" do
    Claim.create!({ statement: "Something", fact_stream_id: "2986b6f7-38e5-4b72-aa0d-df315378bdfa" })

    # Create a second, try and save, and make sure it fails
    assert_raises ActiveRecord::RecordInvalid do
      Claim.create!({ statement: "Something or other", fact_stream_id: "2986b6f7-38e5-4b72-aa0d-df315378bdfa" })
    end
  end

  test "Claim should have a category counter" do
    claim = claims(:one)
    assert 2, claim.categories_count
  end

  test "Claim's category counter should update correctly on adding a claim" do
    claim = claims(:one)
    assert 2, claim.categories_count

    category = claim.categories.first
    category.claims = []
    category.save!

    assert 1, claim.categories_count
  end

  test "Claim's category counter should update correctly when deleting a category" do
    claim = claims(:one)
    assert 2, claim.categories_count

    category = claim.categories.first
    category.destroy!

    assert 1, claim.categories_count
  end

  test "Claim's category counter should update correctly when adding a category" do
    claim = claims(:two)
    assert 1, claim.categories_count

    category = categories(:two)
    claim.categories << category
    claim.save!

    assert 2, claim.categories_count
  end

end
