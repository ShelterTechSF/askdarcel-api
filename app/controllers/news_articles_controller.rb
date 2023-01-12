# frozen_string_literal: true

class NewsArticlesController < ApplicationController
  def create
    news_article = params[:news_article]
    persisted_news_article = NewsArticle.create(headline: news_article[:headline], effective_date: news_article[:effective_date],
                                                body: news_article[:body], priority: news_article[:priority],
                                                expiration_date: news_article[:expiraton_date])
    render status: :created, json: NewsArticlePresenter.present(persisted_news_article)
  end

  def index
    news_articles = NewsArticle.where("effective_date <= ? and (expiration_date is null or expiration_date>=?)", Time.current, Time.current)

    render json: NewsArticlePresenter.present(news_articles)
  end

  # rubocop:disable Metrics/AbcSize
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
  # rubocop:enable Metrics/AbcSize

  def destroy
    news_article = NewsArticle.find params[:id]
    news_article.delete

    render status: :ok
  end
end
