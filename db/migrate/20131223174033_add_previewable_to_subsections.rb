class AddPreviewableToSubsections < ActiveRecord::Migration
  def change
    add_column :subsections, :previewable, :boolean
  end
end
