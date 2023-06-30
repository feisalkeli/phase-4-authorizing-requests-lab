class MembersOnlyArticlesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    if signed_in?

    articles = Article.where(is_member_only: true).includes(:user).order(created_at: :desc)
    render json: articles, each_serializer: ArticleListSerializer
    else
      render json: {error: "Unauthorized user"}, status: :unauthorized_entity
    end
  end

  def show
    if signed_in?
    article = Article.find(params[:id])
    render json: article
    else 
      render json: {error: "Unauthorized user"}, status: :unauthorized_entity
    end
  end

  private

  def record_not_found
    render json: { error: "Article not found" }, status: :not_found
  end
  def signed_in?
    session[:user_id].present?
  end

end
