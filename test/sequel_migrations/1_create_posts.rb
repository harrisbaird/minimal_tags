Sequel.migration do
  change do
    create_table 'posts' do
      column :tags, 'text[]', default: [], null: false
      column :upcase_tags, 'text[]', default: [], null: false
      column :reverse_tags, 'text[]', default: [], null: false
    end
  end
end
