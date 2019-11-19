class ToppagesController < ApplicationController
  helper_method :sort_column, :sort_direction
  def index
    @search_params = user_search_params
    @plans = Plan.search(@search_params).order(sort_column + ' ' + sort_direction).page(params[:page]).per(30)
  end
  
  private
  
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
