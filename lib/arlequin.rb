# frozen_string_literal: true

require "active_support/all"
require "arlequin/middleware"

module Arlequin
  # The `Railtie` class integrates the Arlequin middleware into Rails applications.
  #
  # This Railtie automatically adds the Arlequin middleware to the Rails middleware stack,
  # but it is intended to be used only in the development environment. It helps in monitoring
  # and providing warnings about N+1 SQL queries during development.
  #
  # ## Configuration
  #
  # To use Arlequin in your Rails application, you should include it in the development group
  # of your Gemfile and require it in the application configuration.
  #
  # Example Gemfile configuration:
  #
  #   group :development do
  #     gem 'arlequin'
  #   end
  #
  # To ensure the middleware is used in development, require the Railtie in your application:
  #
  #   # In `config/application.rb`
  #   require "arlequin/railtie"
  #
  #   module YourApp
  #     class Application < Rails::Application
  #       # other configurations
  #       # Ensure that the Railtie is required
  #     end
  #   end
  #
  # This setup will automatically add the Arlequin middleware to the middleware stack
  # when running in development mode. The middleware will then be used to detect and
  # provide warnings for N+1 SQL queries.
  #
  # ## Usage
  #
  # Once configured, the Arlequin middleware will monitor SQL queries and inject a warning
  # into the response HTML if N+1 queries are detected.
  #
  # The Railtie is part of the Arlequin gem and is designed to integrate seamlessly into
  # Rails applications for development purposes, facilitating easier identification and
  # resolution of N+1 query issues.
  class Railtie < Rails::Railtie
    # Initializes the Railtie and configures the Rails application to use the Arlequin middleware.
    #
    # This method is called during the initialization process of the Rails application.
    # It adds the Arlequin middleware to the middleware stack in development environments,
    # allowing it to intercept requests and monitor SQL queries.
    initializer "arlequin.configure_rails_initialization" do |app|
      app.middleware.use Arlequin::Middleware
    end
  end
end
