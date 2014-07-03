require 'rails_helper'

RSpec.describe "reservations/edit", :type => :view do
  before(:each) do
    @reservation = assign(:reservation, Reservation.create!(
      :project => "MyString",
      :is_approved => false,
      :check_out_comments => "MyText",
      :check_in_comments => "MyText"
    ))
  end

  it "renders the edit reservation form" do
    render

    assert_select "form[action=?][method=?]", reservation_path(@reservation), "post" do

      assert_select "input#reservation_project[name=?]", "reservation[project]"

      assert_select "input#reservation_is_approved[name=?]", "reservation[is_approved]"

      assert_select "textarea#reservation_check_out_comments[name=?]", "reservation[check_out_comments]"

      assert_select "textarea#reservation_check_in_comments[name=?]", "reservation[check_in_comments]"
    end
  end
end
