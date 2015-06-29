
class UpdateUserRenameIsEnabled < ActiveRecord::Migration
  def up
    rename_column   :users   , :isEnabled, :is_enabled
    rename_column   :vouchers, :isEnable, :is_enabled

  end

  def down
    rename_column   :users   , :is_enabled, :isEnabled
    rename_column   :vouchers, :is_enabled, :isEnable

  end
end
