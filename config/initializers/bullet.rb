# frozen_string_literal: true

unless Rails.env.production?
  Rails.application.configure do
    config.after_initialize do
      Bullet.enable = Rails.env.test? # Only enable Bullet during testing.
      Bullet.bullet_logger = true
      Bullet.raise = true

      # With the upgrade to Rails 5, bullet has been raising false
      # positives. Disable for now.
      Bullet.unused_eager_loading_enable = false
    end
  end
end
