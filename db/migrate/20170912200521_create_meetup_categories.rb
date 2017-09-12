class CreateMeetupCategories < ActiveRecord::Migration[5.0]
  def change
    create_table :meetup_categories do |t|
      t.string :name
      t.string :sort_name
      t.string :shortname

      t.timestamps
    end
  end
end
