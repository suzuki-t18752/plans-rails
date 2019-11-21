class UsersController < ApplicationController
  before_action :require_user_logged_in, only: [:index, :show, :edit, :destroy, :keeps]
  helper_method :sort_column, :sort_direction
  
  def index
    @users = User.search(params[:search]).order(id: :desc).page(params[:page]).per(25)
  end

  def show
    @user = User.find(params[:id])
    @search_params = user_search_params
    @plans = @user.plans.search(@search_params).order(sort_column + ' ' + sort_direction).page(params[:page]).per(30)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = 'ユーザを登録しました。'
      redirect_to @user
    else
      flash.now[:danger] = 'ユーザの登録に失敗しました。'
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      flash[:success] = 'ユーザ情報を変更しました。'
      redirect_to @user
    else
      flash.now[:danger] = 'ユーザ情報の更新に失敗しました。'
      render :edit
    end
  end

  def destroy
    @user = User.find_by(id: params[:id])
    @user.destroy
    flash[:success] = '退会しました!!'
    redirect_to root_path
  end
  
  def keeps
    @user = User.find(params[:id])
    @keeps = @user.keeps.order(id: :desc).page(params[:page]).per(30).search(params[:search])
  end
  
  
  private

  def user_params
    params.require(:user).permit(:name, :password, :password_confirmation)
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : "desc"
  end

  def sort_column
      Plan.column_names.include?(params[:sort]) ? params[:sort] : "startday"
  end
  
  def user_search_params
    params.fetch(:search, {}).permit(:title, :startday_from, :startday_to, :endday_from, :endday_to)
  end
end
