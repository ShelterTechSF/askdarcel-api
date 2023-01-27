class CreateNewsArticles < ActiveRecord::Migration[6.1]
  def change
    create_table :news_articles do |t|
      t.string :headline
      t.datetime :effective_date
      t.string :body
      t.integer :priority
      t.datetime :expiration_date

      t.timestamps
    end
  end
end
