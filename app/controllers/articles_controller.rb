class ArticlesController < ApplicationController
  def index
    articles = Article.all
    render json: articles
  end

  def create
    article = Article.create(title: params[:title], text: params[:text])
    render json: { article: }
  end

  # private

  # def article_params
  #   params.require(:article).permit(:title, :text)
  # end
end
