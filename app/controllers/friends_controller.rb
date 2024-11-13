class FriendsController < ApplicationController
  before_action :set_friend, only: %i[show edit update destroy]
  # before_action :correct_user, only: %i[edit update destroy]
  before_action :authenticate_user!, only: %i[new create edit update destroy] # if user is not authenticated don't allow any CRUD operations
  before_action :authorize_user!, only: %i[edit update destroy]

  # GET /friends or /friends.json
  def index
    # show only friends where user_id=curent_user.id
    @friends = Friend.where(user_id: current_user.id)
  end

  # GET /friends/1 or /friends/1.json
  def show
  end

  # GET /friends/new
  def new
    # @friend = Friend.new
    @friend = current_user.friends.build
  end

  # GET /friends/1/edit
  def edit
  end

  # POST /friends or /friends.json
  def create
    # @friend = Friend.new(friend_params)
    @friend = current_user.friends.build(friend_params)

    respond_to do |format|
      if @friend.save
        format.html do
          redirect_to @friend, notice: "Friend was successfully created."
        end
        format.json { render :show, status: :created, location: @friend }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json do
          render json: @friend.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /friends/1 or /friends/1.json
  def update
    respond_to do |format|
      if @friend.update(friend_params)
        format.html do
          redirect_to @friend, notice: "Friend was successfully updated."
        end
        format.json { render :show, status: :ok, location: @friend }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json do
          render json: @friend.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /friends/1 or /friends/1.json
  def destroy
    @friend.destroy!

    respond_to do |format|
      format.html do
        redirect_to friends_path,
          status: :see_other,
          notice: "Friend was successfully destroyed."
      end
      format.json { head :no_content }
    end
  end

  # def correct_user
  #   @friend = correct_user.friends.find_by(id: params[:id])

  #   redirect_to friends_path, notice: "Not Authorized!" if @friend.nil?
  # end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_friend
    @friend = Friend.find(params.expect(:id))
  end

  def authorize_user!
    unless @friend.user_id == current_user.id
      redirect_to friends_path, notice: "Not authorized to modify this friend."
    end
  end

  # Only allow a list of trusted parameters through.
  def friend_params
    params.expect(friend: %i[first_name last_name email phone twitter user_id])
  end
end
