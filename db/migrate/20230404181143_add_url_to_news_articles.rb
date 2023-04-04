class AddUrlToNewsArticles < ActiveRecord::Migration[6.1]
  def change
    add_column :news_articles, :url, :string
  end
end
