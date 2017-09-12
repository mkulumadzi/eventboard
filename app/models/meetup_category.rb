class MeetupCategory < ApplicationRecord

  scope :like, ->(term) { where('name ILIKE ?', "%#{term}%")}

  class << self

    def categories_like( query )
      query.split(' ').map do |term|
        like(term.downcase).first
      end.uniq.compact
    end

  end

end
