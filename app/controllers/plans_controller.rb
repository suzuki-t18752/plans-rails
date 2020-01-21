class PlansController < ApplicationController
  before_action :require_user_logged_in
  before_action :set_plan, only: [:show, :edit, :update, :destroy]
  helper_method :sort_column, :sort_direction
  
  def index
    @plans = @user.plans.order(sort_column + ' ' + sort_direction).page(params[:page]).per(30).search(params[:search])
  end
  
  def show
    @tweet_url = URI.encode(
      "http://twitter.com/intent/tweet?original_referer=" +
      request.url +
      "&url=" +
      request.url +
      "&text=" +
      "イベント『" + @plan.title + "』に参加予定です。 #plans" 
    )
  end
  
  def new
    @plan = Plan.new
  end
  
  def create
    @plan = current_user.plans.build(plan_params)

    if @plan.save
      flash[:success] = '予定を作成しました'
      redirect_to current_user
    else
      flash.now[:danger] = '予定を作成できませんでした'
      render :new
    end
  end

  def edit
  end

  def update
    if @plan.update(plan_params)
      flash[:success] = '予定の更新が完了しました'
      redirect_to @plan
    else
      flash.now[:danger] = '予定の更新ができませんでした'
      render :edit
    end
  end

  def destroy
    @plan.destroy

    flash[:success] = '予定を削除しました'
    redirect_to current_user
  end

  private
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : "desc"
  end

  def sort_column
      Plan.column_names.include?(params[:sort]) ? params[:sort] : "startday"
  end
  
  def set_plan
    @plan = Plan.find(params[:id])
  end

  def plan_params
    params.require(:plan).permit(:title, :startday, :endday, :content, :diary)
  end
end
