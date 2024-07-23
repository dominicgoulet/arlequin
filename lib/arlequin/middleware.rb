# frozen_string_literal: true

module Arlequin
  ##
  # Middleware to detect and warn about N+1 queries in a Rails application.
  class Middleware
    ##
    # Initializes the middleware with the given app.
    #
    # @param app [Object] The Rack application this middleware wraps.
    def initialize(app)
      @app = app
    end

    ##
    # Processes the incoming request, detects N+1 queries, and injects a warning
    # into the HTML response if necessary.
    #
    # @param env [Hash] The Rack environment.
    # @return [Array] The status, headers, and response of the Rack application.
    def call(env)
      @queries = Hash.new { |hash, key| hash[key] = 0 }
      ActiveSupport::Notifications.subscribe("sql.active_record", &method(:on_sql))

      status, headers, response = @app.call(env)

      if n_plus_one_detected?
        html_fragment = generate_html_warning
        response = inject_html_fragment(response, html_fragment)
      end

      ActiveSupport::Notifications.unsubscribe("sql.active_record")

      [ status, headers, response ]
    end

    private

    ##
    # Callback for ActiveSupport notifications on SQL queries.
    #
    # @param _name [String] The event name.
    # @param _start [Time] The start time of the event.
    # @param _finish [Time] The finish time of the event.
    # @param _id [String] The event ID.
    # @param payload [Hash] The event payload containing SQL information.
    def on_sql(_name, _start, _finish, _id, payload)
      return if payload[:name] == "SCHEMA"

      query = payload[:sql]
      @queries[query] += 1
    end

    ##
    # Generates warnings for detected N+1 queries.
    #
    # @return [Array<String>] The list of N+1 query warnings.
    def n_plus_one_warnings
      warnings = []

      @queries.each do |query, count|
        if count > 1
          warnings << "N+1 query detected: #{query}, executed #{count} times"
        end
      end

      warnings
    end

    ##
    # Checks if any N+1 queries have been detected.
    #
    # @return [Boolean] True if N+1 queries are detected, otherwise false.
    def n_plus_one_detected?
      @queries.values.any? { |count| count > 1 }
    end

    ##
    # Generates an HTML warning for detected N+1 queries.
    #
    # @return [String] The HTML warning to be injected into the response.
    def generate_html_warning
      "<div style='z-index: 9999; position: fixed; bottom: 0; left: 0; width: 100%; background-color: blue; color: white; text-align: center; padding: 5px;'>" +
        "N+1 query detected! Check your queries. " +
        n_plus_one_warnings.join("<br>") +
      "</div>"
    end

    ##
    # Injects an HTML fragment into the response body.
    #
    # @param response [Array<String>] The original response body.
    # @param fragment [String] The HTML fragment to inject.
    # @return [Array<String>] The modified response body.
    def inject_html_fragment(response, fragment)
      body = + ""

      response.each do |part|
        body << part
      end

      body.sub!("</body>", "#{fragment}</body>")

      [ body ]
    end
  end
end
