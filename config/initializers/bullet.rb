# frozen_string_literal: true

unless Rails.env.production?
  Rails.application.configure do
    config.after_initialize do
      Bullet.enable = Rails.env.test? # Only enable Bullet during testing.
      Bullet.bullet_logger = true
      Bullet.raise = true

      # TODO: We currently believe there's a bug in the N+1 query detector that
      # causes it to detect a false positive w.r.t. the joins and prefetching
      # between Resources and Categories as well as Services and Categories.
      Bullet.n_plus_one_query_enable = false

      # With the upgrade to Rails 5, bullet has been raising false
      # positives. Disable for now.
      Bullet.unused_eager_loading_enable = false
    end
  end
end
