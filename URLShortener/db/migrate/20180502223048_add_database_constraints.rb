class AddDatabaseConstraints < ActiveRecord::Migration[5.1]
  def change
    change_column :shortened_urls, :long_url, :string, null: false
  end
end
