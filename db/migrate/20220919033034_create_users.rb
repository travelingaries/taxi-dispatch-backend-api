# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[7.0]
  def up
    execute <<~SQL.squish
      CREATE TABLE `users`(
        `id`                  integer       PRIMARY KEY AUTOINCREMENT,
        `type`                varchar(255)  DEFAULT NULL,
        `email`               varchar(255)  NOT NULL UNIQUE,
        `password_digest`     varchar(255)  NOT NULL,
        `token`               varchar(255)  DEFAULT NULL,
        `status`              varchar(50)   CHECK( status IN ('inspecting', 'normal', 'restricted', 'deactivated', 'hibernated') ) NOT NULL DEFAULT 'inspecting',
        `created_at`          datetime      NOT NULL,
        `updated_at`          datetime      NOT NULL,
        `data`                text          DEFAULT NULL
      );
      CREATE INDEX `index_users_on_token` ON `users`(`token`);
    SQL
  end
end
