class CreateShortenedUrl < ActiveRecord::Migration[5.1]
  def change
    create_table :shortened_urls do |t|
      t.string :long_url
      t.string :short_url, uniqueness: true
      t.integer :user_id, null: false
      t.timestamps
    end
    add_index(:shortened_urls, :long_url)
    add_index(:shortened_urls, :short_url)
  end
end
