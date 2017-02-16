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

  1. Add not_qwerty123 to your list of dependencies in `mix.exs`:

        def deps do
          [{:not_qwerty123, "~> 2.0"}]
        end
