class ArticlesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    articles = Article.all.includes(:user).order(created_at: :desc)
    render json: articles, each_serializer: ArticleListSerializer
  end

  def show
    # creating a Rails session with a variable name of page_views
    session[:page_views] ||= 0
    
    # incrementing page_views when the React page is viewed
    session[:page_views] += 1

    # if else statement to check if page_views is 3 or less
    if session[:page_views] < 4

    # original code to load articles
    article = Article.find(params[:id])
    render json: article
    
    # if page_views is greater than 3 (4 and above) or less than zero
    else
      render json: {error: "Maximum pageview limit reached"}, status: :unauthorized
    end

  end

  private

  def record_not_found
    render json: { error: "Article not found" }, status: :not_found
  end

end
