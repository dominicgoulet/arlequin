# Arlequin

**Arlequin** is a Ruby gem that helps detect and warn about N+1 SQL queries in Rails applications. It includes middleware that integrates seamlessly with your Rails application to improve performance by identifying inefficient database queries.

## Features

- **N+1 Query Detection**: Automatically detects and warns about N+1 query problems.
- **Integration**: Easy integration with Rails applications through a Railtie.
- **Performance Insights**: Provides detailed insights into query performance issues.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'arlequin', group: [ :development ]
```

Then execute:

```bash
$ bundle install
```

## Usage

### Basic Setup

To start using Arlequin, simply add the following to your Rails application’s configuration file (config/application.rb):

```ruby
require 'arlequin'
```

### Middleware
Arlequin integrates with Rails as middleware. It will automatically start monitoring SQL queries for N+1 problems.
No additional setup is required beyond including it in your Gemfile and configuration.

## Example

Suppose you have a Rails application with a Post model that has many Comments. If you inadvertently write code like:

```ruby
@posts = Post.all
@posts.each do |post|
  puts post.comments.count
end
```

Arlequin will detect this N+1 query issue and warn you about it in the UI.

## Development

To contribute to Arlequin, clone the repository and run the test suite:

```bash
git clone https://github.com/dominicgoulet/arlequin.git
cd arlequin
bundle install
rake test
```

Make sure to write tests for any new features or bug fixes you add.
Follow the existing coding style and conventions used in the project.

## Contributing

We welcome contributions! Please submit pull requests and issues through GitHub.
Ensure your code adheres to the project’s style and includes appropriate tests.

## License

Arlequin is released under the MIT License.

## Contact

For any questions or feedback, feel free to reach out to us at [dominic@dominicgoulet.com].
