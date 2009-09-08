class HeadwordUpdateUsers < ActiveRecord::Migration
  def self.up
<% 
    existing_columns = ActiveRecord::Base.connection.columns(:users).collect { |each| each.name }
    columns = [
      [:url,              't.string :url, :null => false'],
      [:username,         't.string :username, :null => false']
    ].delete_if {|c| existing_columns.include?(c.first.to_s)} 
-%>
    change_table(:users) do |t|
<% columns.each do |c| -%>
      <%= c.last %>
<% end -%>
    end
    
<%
    existing_indexes = ActiveRecord::Base.connection.indexes(:users)
    index_names = existing_indexes.collect { |each| each.name }
    new_indexes = [
      [:index_users_on_id_and_url, 'add_index :users, [:url, :id]']
    ].delete_if { |each| index_names.include?(each.first.to_s) }
-%>
<% new_indexes.each do |each| -%>
    <%= each.last %>
<% end -%>
  end
  
  def self.down
    change_table(:pages) do |t|
<% unless columns.empty? -%>
      t.remove <%= columns.collect { |each| ":#{each.first}" }.join(',') %>
<% end -%>
    end
  end
end
