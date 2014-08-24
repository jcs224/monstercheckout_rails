require 'rails_helper'

RSpec.describe 'reservations/show', :type => :view do
  before(:each) do
    @out_time = 1.days.ago
    @in_time = 1.days.from_now
    @user = FactoryGirl.create(:user)
    @equipment = [FactoryGirl.create(:equipment), FactoryGirl.create(:equipment)]
    @reservation = assign(:reservation, Reservation.create!(
      :user_id => @user.id,
      :project => 'Project',
      :out_time => @out_time,
      :in_time => @in_time,
      :is_approved => false,
    ))
    @test_user = stub_model(User)
    view.stub(:current_user).and_return @test_user
    @test_user.stub(:is_admin?).and_return false
  end

  it 'renders attributes' do
    render
    expect(rendered).to match(@user.name)
    expect(rendered).to match(/Project/)
    expect(rendered).to match(@out_time.strftime('%A, %B %d, %Y, %I:%M %p'))
    expect(rendered).to match(@in_time.strftime('%A, %B %d, %Y, %I:%M %p'))
  end

  describe 'when reservation is awaiting approval' do
    
    describe 'as an admin user' do
      before(:each) do
        @test_user.stub(:is_admin?).and_return true
        @reservation.stub(:requested?).and_return true
      end

      it 'should render approve/deny buttons' do
        render

        assert_select 'a.btn.btn-large.btn-success[href=?]', approve_reservation_path(@reservation), text: 'Approve'
        assert_select 'a.btn.btn-large.btn-danger[href=?]', deny_reservation_path(@reservation), text: 'Deny'
      end
    end

    describe 'as a non-admin user' do
      it 'should render approve/deny buttons' do
        render

        assert_select 'a.btn.btn-large.btn-success[href=?]', approve_reservation_path(@reservation), text: 'Approve', count: 0
        assert_select 'a.btn.btn-large.btn-danger[href=?]', deny_reservation_path(@reservation), text: 'Deny', count: 0
      end
    end
  end

  describe 'when user can edit' do
    before(:each) do 
      @reservation.stub(:can_edit?).with(@test_user).and_return true
    end

    it 'should render edit button' do
      render

      assert_select 'a.btn.btn-large.btn-primary[href=?]', edit_reservation_path(@reservation), text: 'Edit', count: 1
    end
  end

  describe 'when user can not edit' do
    before(:each) do 
      @reservation.stub(:can_edit?).with(@test_user).and_return false
    end

    it 'should not render edit button' do
      render

      assert_select 'a.btn.btn-large.btn-primary[href=?]', edit_reservation_path(@reservation), text: 'Edit', count: 0
    end
  end
end
