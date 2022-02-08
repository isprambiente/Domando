# frozen_string_literal: true

# This controller manage the views refering to {User} model
# === before_action :{set_user}, only: [:show, :edit, :update, :destroy, unlock, trash}
class UsersController < ApplicationController
  include Pagy::Backend
  load_and_authorize_resource
  before_action :authenticate_admin!
  before_action :set_user, only: %i[show edit update destroy unlock trash]

  # GET /users
  #
  # render users index
  # set @pagy, @users for the users pagination
  # @return [Object] render users/index
  def index; end

  # GET /users/list
  #
  # render users list
  # set @pagy, @users for the users pagination
  # @return [Object] render users/list
  def list
    users
    flash.now[:success] = 'Caricamento completato'
  end

  # GET /users/1
  #
  # render users show
  # @return [Object] render users/show
  def show
    @view = params[:view] || ''
    @current_ability.cannot(:manage, @user) if @view == 'modal'
  end

  # GET /users/new
  #
  # Render the form for create a new user
  # set @user as new {User}
  # @return [Object] rendeer users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  #
  # Render the form for edit a user
  # {set_user} has set @user for edit
  # @return [Object] render users/edit
  def edit; end

  # POST /users
  #
  # Create a new User
  # set @user as new {User} with {user_params} as param
  # @return [Object] render users/index if @user is created or users/new if fail
  def create
    @user = User.new(user_params)
    if @user.save
      UsersCheckJob.perform_now(username: @user.username)
      flash.now[:success] = 'Creazione avvenuta con successo'
      render turbo_stream: [
          turbo_stream.replace(:flashes, partial: "flashes"),
          turbo_stream.replace(:yield, partial: "users/show", locals: { user: @user.reload, tab: @tab })
      ]
    else
      flash.now[:error] =  write_errors(@user)
      render turbo_stream: turbo_stream.replace(:flashes, partial: "flashes")
    end
  end

  # PATCH/PUT /users/1
  #
  # update a user
  # {set_user} has set @user for update
  # and update with {user_params} as param
  # @return [Object] render users/index if @user is updated or users/new if fail
  def update
    if @user.update(user_params)
      flash.now[:success] = 'Modifica avvenuta con successo'
    else
      flash.now[:error] = write_errors(@user)
    end
    render turbo_stream: turbo_stream.replace(:flashes, partial: "flashes")
  end

  # DELETE /users/1
  #
  # lock a user
  #
  # * {set_user} has set @user for destroy
  # @return [Object] render users/list
  def destroy
    if @user.disable!
      flash.now[:success] = 'Disattivazione avvenuta con successo'
      render turbo_stream: [
          turbo_stream.replace("user_#{@user.id}", partial: 'users/user', locals: {user: @user, current_user: current_user}),
          turbo_stream.replace(:flashes, partial: "flashes")
        ]
    else
      flash.now[:error] = write_errors(@user)
      format.turbo_stream { render turbo_stream: turbo_stream.replace(:flashes, partial: "flashes") }
    end
  end

  # PATCH /users/1/unlock
  #
  # unlock a user
  #
  # * {set_user} has set @user for unlock
  # @return [Object] render users/list
  def unlock
    if @user.enable!
      flash.now[:success] = 'Riattivazione avvenuta con successo'
      render turbo_stream: [
        turbo_stream.replace("user_#{@user.id}", partial: 'users/user', locals: {user: @user, current_user: current_user}),
        turbo_stream.replace(:flashes, partial: "flashes")
      ]
    else
      flash.now[:error] = write_errors(@user)
      render turbo_stream: turbo_stream.replace(:flashes, partial: "flashes")
    end
  end

  # DELETE /users/1/trash
  #
  # destroy a user
  #
  # * {set_user} has set @user for destroy
  # @return [Object] render users/list
  def trash
    @user.forced = 'true'
    if @user.destroy
      flash.now[:success] = 'Cancellazione avvenuta con successo'
      render turbo_stream: [
          turbo_stream.remove("user_#{@user.id}"),
          turbo_stream.replace(:flashes, partial: "flashes")
        ]
    else
      flash.now[:error] = write_errors(@user)
      render turbo_stream: turbo_stream.replace(:flashes, partial: "flashes")
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def user_params
    params.fetch(:user, {}).permit(:username, :label, :email, :structure, :admin, :editor)
  end

  # Only allow a list of trusted parameters through.
  def filter_params
    params.fetch(:filter, {}).permit(:text)
  end

  # Only allow a list of trusted parameters through.
  def sort_params
    params.fetch(:sort, {}).permit(:label, :username, :last_sign_in_at, :admin, :editor, :locked_at)
  end

  # Set @pagy, @users for paginate all {User}
  def users
    @filters = filter_params
    @sorted = sort_params
    @page = params[:page] || 1
    users = User.all
    users = users.where("label ilike ? or username ilike ? or email ilike ?", "%#{@filters[:text]}%", "%#{@filters[:text]}%", "%#{@filters[:text]}%") if @filters[:text].present?
    @pagy, @users = pagy(users, page: @page, link_extra: "data-turbo-frame='users'")
  end

  # deny access unless current_user is an editor
  def authenticate_admin!
    access_denied! unless user_signed_in? && current_user.admin?
  end
end
