# == Schema Information
#
# Table name: shortened_urls
#
#  id         :bigint(8)        not null, primary key
#  long_url   :string           not null
#  short_url  :string           not null
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Shortened_url < ApplicationRecord
  validates :user_id, :long_url, :short_url, presence: true
  validates :short_url, uniqueness: true

  belongs_to :submitter,
  primary_key: :id,
  foreign_key: :user_id,
  class_name: :User

  has_many :visits,
  primary_key: :id,
  foreign_key: :shortened_url_id,
  class_name: :Visit

  has_many :visitors,
  through: :visits,
  source: :user

  has_many :distinct_visitors,
  Proc.new { distinct },
  through: :visits,
  source: :user

  def self.random_code
    generated = false
    until generated
      short_url = SecureRandom.urlsafe_base64(16)
      generated = true unless Shortened_url.exists?(short_url: short_url)
    end
    short_url
  end

  def self.create!(options)
    short_url = Shortened_url.random_code
    new_class = Shortened_url.new(user_id: options[:user_id], short_url: short_url, long_url: options[:long_url])
    new_class.save!
  end

  def num_clicks
    visits.length
  end

  def num_uniques
    distinct_visitors.length
  end

  def num_recent_uniques
     visitors = visits
     # this select narrows it down to visitors in the last 20 minutes
     visitors = visitors.select { |visitor| visitor[:updated_at] >= 20.minutes.ago }
     results = []
     visitors.each do |visitor|
       results.push(visitor[:user_id]) unless results.include?(visitor[:user_id])
     end
     results.length
  end

end
