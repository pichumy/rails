class AddValidationToShortenedUrl < ActiveRecord::Migration[5.1]
  def change
    change_column :shortened_urls, :short_url, :string, null: false
    remove_index :shortened_urls, :short_url
    add_index :shortened_urls, :short_url, unique: true
  end
end
