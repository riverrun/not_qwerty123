# NotQwerty123

Elixir library to check password strength and generate random passwords.

The `NotQwerty123.PasswordStrength` module provides checks that the
password is not too easy to guess. These checks check that the password
is long enough and that it is not similar to any common passwords.

The `NotQwerty123.RandomPassword` module generates a random password
with letters, digits and punctuation characters.

## Installation

Make sure you are using Elixir 1.4 or above.

The package can be installed as:

  1. Add `not_qwerty123` to your list of dependencies in `mix.exs`:

        def deps do
          [{:not_qwerty123, "~> 2.2"}]
        end
  2. If updating a pre-Elixir 1.4 app, make sure you change:

        def application do
          [applications: [:logger]]
        end

    to:

        def application do
          [extra_applications: [:logger]]
        end

    or add `not_qwerty123` to the `applications` list.

See [Elixir 1.4 release notes](http://elixir-lang.org/blog/2017/01/05/elixir-v1-4-0-released/#application-inference)
for details.
