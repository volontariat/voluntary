# This migration comes from voluntary_engine (originally 20120919161831)
class AddUniqueIndexForOneUserCandidaturePerVacancy < ActiveRecord::Migration
  def up
    add_index :candidatures, [:user_id, :vacancy_id], unique: true
  end

  def down
    remove_index :candidatures, [:user_id, :vacancy_id]
  end
end
