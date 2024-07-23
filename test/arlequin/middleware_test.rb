# frozen_string_literal: true

require "arlequin/middleware"

##
# MiddlewareTest tests the functionality of the Arlequin::Middleware class,
# ensuring it correctly detects and warns about N+1 queries in a Rails application.
class MiddlewareTest < Minitest::Test
  ##
  # Sets up the test environment by initializing the app and middleware instances.
  def setup
    @app = lambda { |env| [ 200, { "Content-Type" => "text/html" }, [ "<html><body>Hello World</body></html>" ] ] }
    @middleware = Arlequin::Middleware.new(@app)
  end

  ##
  # Tests the middleware call method without N+1 queries.
  #
  # Asserts that the status is 200, the Content-Type header is "text/html",
  # and the response includes the expected HTML content.
  def test_call_without_n_plus_one
    status, headers, response = @middleware.call({})

    assert_equal 200, status
    assert_equal "text/html", headers["Content-Type"]
    assert_includes response, "<html><body>Hello World</body></html>"
  end

  ##
  # Tests the middleware call method with N+1 queries.
  #
  # Simulates N+1 queries and asserts that the status is 200, the Content-Type header is "text/html",
  # and the response includes warnings about the N+1 queries.
  def test_call_with_n_plus_one
    simulate_n_plus_one_queries

    status, headers, response = @middleware.call({})

    assert_equal 200, status
    assert_equal "text/html", headers["Content-Type"]
    assert_includes response.join, "N+1 query detected"
    assert_includes response.join, "SELECT * FROM users, executed 2 times"
  end

  ##
  # Tests the inject_html_fragment method of the middleware.
  #
  # Asserts that the HTML fragment is correctly injected into the original response.
  def test_inject_html_fragment
    original_response = [ "<html><body>Hello World</body></html>" ]
    fragment = "<div>N+1 warning</div>"
    modified_response = @middleware.send(:inject_html_fragment, original_response, fragment)

    expected_response = "<html><body>Hello World<div>N+1 warning</div></body></html>"
    assert_equal [ expected_response ], modified_response
  end

  ##
  # Tests the n_plus_one_detected? method of the middleware.
  #
  # Asserts that N+1 queries are correctly detected.
  def test_n_plus_one_detected?
    @middleware.instance_variable_set(:@queries, { "SELECT * FROM users" => 2 })
    assert @middleware.send(:n_plus_one_detected?)

    @middleware.instance_variable_set(:@queries, { "SELECT * FROM users" => 1 })
    refute @middleware.send(:n_plus_one_detected?)
  end

  ##
  # Tests the generate_html_warning method of the middleware.
  #
  # Asserts that the correct HTML warning is generated for N+1 queries.
  def test_generate_html_warning
    @middleware.instance_variable_set(:@queries, { "SELECT * FROM users" => 2 })
    expected_warning = "<div style='z-index: 9999; position: fixed; bottom: 0; left: 0; width: 100%; background-color: blue; color: white; text-align: center; padding: 5px;'>" +
                       "N+1 query detected! Check your queries. N+1 query detected: SELECT * FROM users, executed 2 times" +
                       "</div>"
    assert_equal expected_warning, @middleware.send(:generate_html_warning)
  end

  private

  ##
  # Simulates N+1 queries by instrumenting ActiveSupport notifications for SQL queries.
  #
  # Sets up a mock app that simulates the execution of the same SQL query twice.
  def simulate_n_plus_one_queries
    @app = lambda do |env|
      2.times do
        ActiveSupport::Notifications.instrument("sql.active_record", sql: "SELECT * FROM users", name: "User Load")
      end
      [ 200, { "Content-Type" => "text/html" }, [ "<html><body>Hello World</body></html>" ] ]
    end
    @middleware = Arlequin::Middleware.new(@app)
  end
end
