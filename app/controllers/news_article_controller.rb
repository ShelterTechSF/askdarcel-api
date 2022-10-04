# frozen_string_literal: true

class NewsArticleController < ApplicationController
  def create
    news_article = params[:news_article]
    persisted_news_article = NewsArticle.create(news_article[:news_article])
    render status: :created, json: NewsArticlePresenter.present(persisted_news_article)
  end

  def retrieve
    news_articles = NewsArticle.where("effective_date is <= ?", Time.current).where(
      "(expiration_date = ? or DATE(expiration_date) > ?)", nil, Time.current
    )
    render json: NewsArticlePresenter.present(news_articles)
  end

  def update
    news_article = NewsArticle.find(params[:id])
    news_article.headline = params[:news_article][:headline]
    news_article.effective_date = params[:news_article][:effective_date]
    news_article.body = params[:news_article][:body]
    news_article.priority = params[:news_article][:priority]
    news_article.expiration_date = params[:news_article][:expiration_date]

    news_article.save

    render status: :ok, json: NewsArticlePresenter.present(news_article)
  end

  def delete
    news_article = NewsArticle.find params[:id]
    news_article.delete

    render status: :ok
  end
end
