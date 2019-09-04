class RelationshipsController < ApplicationController
  before_action :logged_in_user

  def create
    user = User.find(params[:followed_id])
    current_user.follow(user)
    redirect_to user

    # This was an Ajax thing but it was already fine
    # respond_to do |format|
    #   format.html { redirect_to @user }
    #   format.js
    # end
  end

  def destroy
    user = Relationship.find(params[:id]).followed
    current_user.unfollow(user)
    redirect_to user

    # This was an Ajax thing but it was already fine
    # respond_to do |format|
    #   format.html { redirect_to @user }
    #   format.js
    # end
  end
end
