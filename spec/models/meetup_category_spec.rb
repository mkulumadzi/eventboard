require 'rails_helper'

RSpec.describe MeetupCategory, type: :model do

  describe 'categories_like' do

    before do
      MeetupCategory.create!(name: "Sports")
      MeetupCategory.create!(name: "Arts and Crafts")
    end

    it 'returns a category if the term matches' do
      expect(MeetupCategory.categories_like('Spor').count).to eq(1)
    end

    it 'returns a category if the term matches on lowercase' do
      expect(MeetupCategory.categories_like('sports').count).to eq(1)
    end

    it 'returns multiple categories by searching on the query split on space' do
      expect(MeetupCategory.categories_like('Arts Sports').count).to eq(2)
    end

    it 'returns unique categories' do
      expect(MeetupCategory.categories_like('Arts Crafts').count).to eq(1)
    end

    it 'returns an empty array if there is not a match' do
      expect(MeetupCategory.categories_like('Science').count).to eq(0)
    end

  end

end
