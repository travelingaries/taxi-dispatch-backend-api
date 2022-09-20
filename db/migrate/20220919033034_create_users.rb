class CreateUsers < ActiveRecord::Migration[7.0]
  def up
    execute <<-SQL
CREATE TABLE `users`(
  `id`                  integer       PRIMARY KEY AUTOINCREMENT,
  `type`                varchar(255)  DEFAULT NULL,
  `email`               varchar(255)  NOT NULL UNIQUE,
  `password_digest`     varchar(255)  NOT NULL,
  `token`               varchar(255)  DEFAULT NULL,
  `status`              tinyint(1)    NOT NULL DEFAULT 0,
  `created_at`          datetime      NOT NULL,
  `updated_at`          datetime      NOT NULL,
  `data`                text          DEFAULT NULL
);
CREATE INDEX `index_users_on_token` ON `users`(`token`);
    SQL
  end
end
