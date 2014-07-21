class CommentTable < ActiveRecord::Migration
  def up
    create_table :comments do |t|
      t.string  :comment
      t.string  :message_id
    end
  end

  def down
    drop_table :comments
  end
end
