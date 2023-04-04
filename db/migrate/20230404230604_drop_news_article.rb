class DropNewsArticle < ActiveRecord::Migration[6.1]
  def change
   drop_table(:news_article, if_exists: true)
  end
end
