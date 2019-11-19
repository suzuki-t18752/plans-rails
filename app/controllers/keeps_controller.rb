class KeepsController < ApplicationController
  before_action :require_user_logged_in
  
  def create
    keep = current_user.keeps.build(plan_id: params[:plan_id])
    keep.save
    redirect_to current_user
  end

  def destroy
    keep = Keep.find_by(plan_id: params[:plan_id], user_id: current_user.id)
    keep.destroy
    redirect_to current_user
  end
end
