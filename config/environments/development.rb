AdnApp::Application.configure do

    config.after_initialize do
        Bullet.enable = true
        Bullet.bullet_logger = true
        Bullet.console = true
        Bullet.rails_logger = true
    end

    # Settings specified here will take precedence over those in config/application.rb

    # In the development environment your application's code is reloaded on
    # every request. This slows down response time but is perfect for development
    # since you don't have to restart the web server when you make code changes.
    config.cache_classes = false

    # Show full error reports and disable caching
    config.consider_all_requests_local       = true
    config.action_controller.perform_caching = false

    # Don't care if the mailer can't send
    config.action_mailer.default_url_options = { :host => "example.com" }
    config.action_mailer.raise_delivery_errors = false
    config.action_mailer.delivery_method = :test

    # Print deprecation notices to the Rails logger
    config.active_support.deprecation = :log

    # Set logging level
    config.log_level = :info

    # Expands the lines which load the assets
    config.assets.debug = true
    config.eager_load = false
    config.paperclip_defaults = {
        :storage => :s3,
        :s3_credentials => {
            :bucket => 'solutionADN',
            :access_key_id => 'AKIAI64CIDYISKINB6JA',
            :secret_access_key => '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'
        }
    }

end
