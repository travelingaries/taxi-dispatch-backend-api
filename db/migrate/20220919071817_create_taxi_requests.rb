# frozen_string_literal: true

class CreateTaxiRequests < ActiveRecord::Migration[7.0]
  def up
    execute <<~SQL.squish
CREATE TABLE `taxi_requests` (
  `id`              integer       PRIMARY KEY AUTOINCREMENT,
  `passenger_id`    int(11)       NOT NULL,
  `driver_id`       int(11)       DEFAULT NULL,
  `address`         varchar(255)  NOT NULL,
  `status`          varchar(50)   CHECK( status IN ('waiting', 'accepted', 'canceled', 'completed') ) NOT NULL DEFAULT 'waiting',
  `accepted_at`     datetime      DEFAULT NULL,
  `created_at`      datetime      NOT NULL,
  `updated_at`      datetime      NOT NULL
);
CREATE INDEX `index_taxi_requests_on_passenger_id` ON `taxi_requests`(`passenger_id`);
CREATE INDEX `index_taxi_requests_on_created_at` ON `taxi_requests`(`created_at`);
    SQL
  end
end
