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

require 'rails_helper'

RSpec.describe SubItem, :type => :model do
  
  before { @item = FactoryGirl.create(:sub_item)}

  it 'should respond to attributes' do
  	expect(@item).to respond_to(:name)
  	expect(@item).to respond_to(:brand)
  	expect(@item).to respond_to(:description)
  	expect(@item).to respond_to(:is_optional?)
  	expect(@item).to respond_to(:kit)
    expect(@item).to respond_to(:reservations)
  end

  it 'should have a valid factory' do
    expect(@item).to be_valid
  end

  it 'should be invalid without a name' do
    @item.name = ''
    expect(@item).to_not be_valid
  end

  it 'should be invalid without a description' do
    @item.description = ''
    expect(@item).to_not be_valid
  end

  it 'should be invalid without a kit' do
    @item.kit = nil
    expect(@item).to_not be_valid
  end
end
