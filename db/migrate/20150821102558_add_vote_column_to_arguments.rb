class AddVoteColumnToArguments < ActiveRecord::Migration
  def change
    add_column :arguments, :user_id, :integer
    add_column :arguments, :vote, :boolean
  end
end
