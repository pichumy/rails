# == Schema Information
#
# Table name: visits
#
#  id               :bigint(8)        not null, primary key
#  shortened_url_id :integer          not null
#  user_id          :integer          not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Visit < ApplicationRecord
  validates :user_id, :shortened_url_id, presence: true

  belongs_to :user,
    primary_key: :id,
    foreign_key: :user_id,
    class_name: :User

  belongs_to :url,
    primary_key: :id,
    foreign_key: :shortened_url_id,
    class_name: :Shortened_url

  def self.record_visit!(user, shortened_url)
    new_class = Visit.new(user_id: user, shortened_url_id: shortened_url)
    new_class.save!
  end

end
