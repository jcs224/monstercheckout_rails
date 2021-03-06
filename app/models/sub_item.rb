# == Schema Information
#
# Table name: sub_items
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  brand       :string(255)
#  kit_id      :integer
#  description :text
#  is_optional :boolean
#  created_at  :datetime
#  updated_at  :datetime
#

class SubItem < ActiveRecord::Base
  belongs_to :kit, class_name: 'Equipment'
  has_and_belongs_to_many :reservations

  validates :name, presence: true
  validates :description, presence: true
  validates :kit_id, presence: true
end
