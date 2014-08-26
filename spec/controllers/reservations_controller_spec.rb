require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe ReservationsController, :type => :controller do

  # This should return the minimal set of attributes required to create a valid
  # Reservation. As you add validations to Reservation, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    { user_id: FactoryGirl.create(:user).id,
      project: 'Make phat beats',
      out_time: 1.days.ago,
      in_time: 2.days.from_now} 
  }

  let(:invalid_attributes) {
    { project: '', out_time: Time.now, in_time: 1.days.ago }
  }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # ReservationsController. Be sure to keep this updated too.
  def valid_session
    controller.stub(:user_signed_in).and_return(true)
  end

  def non_admin_session
    valid_session
    user = stub_model(User)
    user.stub(:is_admin?).and_return false
    controller.stub(:current_user).and_return(user)
  end

  def admin_session
    valid_session
    admin = stub_model(User)
    admin.stub(:is_admin?).and_return true
    controller.stub(:current_user).and_return admin 
    controller.stub(:user_is_admin).and_return true
  end

  def monitor_session
    valid_session
    monitor = stub_model(User)
    monitor.stub(:monitor_access?).and_return true
    controller.stub(:current_user).and_return monitor 
    controller.stub(:user_is_admin).and_return true
  end

  def non_monitor_session
    valid_session
    user = stub_model(User)
    user.stub(:monitor_access?).and_return false
    controller.stub(:current_user).and_return user 
    controller.stub(:user_is_admin).and_return true
  end

  describe 'GET index' do
    it 'assigns user reservations as @user_reservations' do
      reservation = Reservation.create! valid_attributes
      controller.stub(:current_user).and_return reservation.user
      get :index, {}, valid_session
      expect(assigns(:user_reservations)).to eq([reservation])
    end
  end

  describe 'GET show' do
    it 'assigns the requested reservation as @reservation' do
      reservation = Reservation.create! valid_attributes
      get :show, {:id => reservation.to_param}, valid_session
      expect(assigns(:reservation)).to eq(reservation)
    end
  end

  describe 'GET new' do
    it 'assigns a new reservation as @reservation' do
      get :new, {}, valid_session
      expect(assigns(:reservation)).to be_a_new(Reservation)
    end
  end

  describe 'GET edit' do
    it 'assigns the requested reservation as @reservation' do
      reservation = Reservation.create! valid_attributes
      get :edit, {:id => reservation.to_param}, valid_session
      expect(assigns(:reservation)).to eq(reservation)
    end
  end

  describe 'POST create' do
    describe 'with valid params' do
      it 'creates a new Reservation' do
        expect {
          post :create, {:reservation => valid_attributes}, valid_session
        }.to change(Reservation, :count).by(1)
      end

      it 'assigns a newly created reservation as @reservation' do
        post :create, {:reservation => valid_attributes}, valid_session
        expect(assigns(:reservation)).to be_a(Reservation)
        expect(assigns(:reservation)).to be_persisted
      end

      it 'has a status of requested' do
        post :create, {:reservation => valid_attributes}, valid_session
        expect(assigns(:reservation).status).to eq('requested')
      end

      it 'redirects to the created reservation' do
        post :create, {:reservation => valid_attributes}, valid_session
        expect(response).to redirect_to(Reservation.last)
      end
    end

    describe 'with invalid params' do
      it 'assigns a newly created but unsaved reservation as @reservation' do
        post :create, {:reservation => invalid_attributes}, valid_session
        expect(assigns(:reservation)).to be_a_new(Reservation)
      end

      it "re-renders the 'new' template" do
        post :create, {:reservation => invalid_attributes}, valid_session
        expect(response).to render_template('new')
      end
    end
  end

  describe 'PUT update' do
    describe 'with valid params' do
      # If we use from_now in tests we need to define a constant
      let(:new_out_time) { 1.days.from_now.change(:usec => 0) }
      let(:new_in_time) { 2.days.from_now.change(:usec => 0) }
      let(:new_attributes) {
        { project: 'Make more phat beats', out_time: new_out_time, in_time: new_in_time }
      }

      it 'updates the requested reservation' do
        reservation = Reservation.create! valid_attributes
        put :update, {:id => reservation.to_param, :reservation => new_attributes}, valid_session
        reservation.reload
        expect(reservation.project).to eq('Make more phat beats')
        expect(reservation.out_time).to eq(new_out_time)
        expect(reservation.in_time).to eq(new_in_time)
      end

      it 'assigns the requested reservation as @reservation' do
        reservation = Reservation.create! valid_attributes
        put :update, {:id => reservation.to_param, :reservation => valid_attributes}, valid_session
        expect(assigns(:reservation)).to eq(reservation)
      end

      it 'redirects to the reservation' do
        reservation = Reservation.create! valid_attributes
        put :update, {:id => reservation.to_param, :reservation => valid_attributes}, valid_session
        expect(response).to redirect_to(reservation)
      end

      describe 'with approved reservation' do
        it 'unapproves the reservation' do
          reservation = Reservation.create! valid_attributes
          reservation.is_approved = true
          reservation.status = :approved
          reservation.save

          put :update, {:id => reservation.to_param, :reservation => valid_attributes}, valid_session
          reservation.reload
          expect(reservation.is_approved).to eq(false)
          expect(reservation.status).to eq('requested')
        end
      end

      describe 'with denied reservation' do
        it 'unapproves the reservation' do
          reservation = Reservation.create! valid_attributes
          reservation.is_denied = true
          reservation.status = :denied
          reservation.save

          put :update, {:id => reservation.to_param, :reservation => valid_attributes}, valid_session
          reservation.reload
          expect(reservation.is_denied).to eq(false)
          expect(reservation.status).to eq('requested')
        end
      end
    end

    describe 'with invalid params' do
      it 'assigns the reservation as @reservation' do
        reservation = Reservation.create! valid_attributes
        put :update, {:id => reservation.to_param, :reservation => invalid_attributes}, valid_session
        expect(assigns(:reservation)).to eq(reservation)
      end

      it "re-renders the 'edit' template" do
        reservation = Reservation.create! valid_attributes
        put :update, {:id => reservation.to_param, :reservation => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe 'DELETE destroy' do
    describe 'when current_user is admin' do
      it 'destroys the requested reservation' do
        reservation = Reservation.create! valid_attributes
        expect {
          delete :destroy, {:id => reservation.to_param}, admin_session
        }.to change(Reservation, :count).by(-1)
      end

      it 'redirects to the reservations list' do
        reservation = Reservation.create! valid_attributes
        delete :destroy, {:id => reservation.to_param}, admin_session
        expect(response).to redirect_to(reservations_url)
      end
    end

    describe 'when current_user is not admin' do
      it 'does not destroy the requested reservation' do
        reservation = Reservation.create! valid_attributes
        expect {
          delete :destroy, {:id => reservation.to_param}, non_admin_session
        }.to_not change(Reservation, :count)
      end

      it 'redirects to the reservations list' do
        reservation = Reservation.create! valid_attributes
        delete :destroy, {:id => reservation.to_param}, non_admin_session
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'GET approve' do
    describe 'when current_user is admin' do
      it 'changes the approved status of the reservation' do
        reservation = FactoryGirl.create(:reservation)
        get :approve, {:id => reservation.to_param}, admin_session
        reservation.reload
        expect(reservation.is_approved?).to eq(true)
        expect(reservation.status).to eq('approved')
        expect(reservation.admin_response_time).to_not eq(nil)
      end

      it 'redirects to show page' do
        reservation = FactoryGirl.create(:reservation)
        get :approve, {:id => reservation.to_param}, admin_session

        expect(response).to redirect_to(reservation)
      end
    end

    describe 'when current_user is not admin' do
      it 'does not change the approved status of the reservation' do
        reservation = FactoryGirl.create(:reservation)
        get :approve, {:id => reservation.to_param}, non_admin_session
        reservation.reload
        expect(reservation.is_approved?).to eq(false)
        expect(reservation.status).to eq('requested')
      end

      it 'redirects to show page' do
        reservation = FactoryGirl.create(:reservation)
        get :approve, {:id => reservation.to_param}, non_admin_session

        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'GET deny' do
    describe 'when current_user is admin' do
      it 'changes the denied status of the reservation' do
        reservation = FactoryGirl.create(:reservation)
        get :deny, {:id => reservation.to_param}, admin_session
        reservation.reload
        expect(reservation.is_denied?).to eq(true)
        expect(reservation.status).to eq('denied')
        expect(reservation.admin_response_time).to_not eq(nil)
      end

      it 'redirects to show page' do
        reservation = FactoryGirl.create(:reservation)
        get :deny, {:id => reservation.to_param}, admin_session

        expect(response).to redirect_to(reservation)
      end
    end

    describe 'when current_user is not admin' do
      it 'does not change the denied status of the reservation' do
        reservation = FactoryGirl.create(:reservation)
        get :deny, {:id => reservation.to_param}, non_admin_session
        reservation.reload
        expect(reservation.is_denied?).to eq(false)
        expect(reservation.status).to eq('requested')
      end

      it 'redirects to show page' do
        reservation = FactoryGirl.create(:reservation)
        get :deny, {:id => reservation.to_param}, non_admin_session

        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe 'GET checkout' do
    describe 'when current_user is monitor' do
      it 'assigns the requested reservation as @reservation' do
        reservation = Reservation.create! valid_attributes
        get :checkout, {:id => reservation.to_param}, monitor_session
        expect(assigns(:reservation)).to eq(reservation)
      end
    end

    describe 'when current_user is not monitor' do
      it 'redirects to root_path' do
        reservation = Reservation.create! valid_attributes
        get :checkout, {:id => reservation.to_param}, non_monitor_session
        expect(response).to redirect_to(root_path)
      end
    end
  end
end

