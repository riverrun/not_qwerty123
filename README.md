# NotQwerty123

Elixir library to generate random passwords and check password strength.

The `NotQwerty123.RandomPassword` module generates a random password
with letters, digits and punctuation characters.

The `NotQwerty123.PasswordStrength` module provides checks that the
password is not too easy to guess. These checks check that the password
is long enough, it contains at least one digit and one punctuation
character, and it is not similar to any common passwords.

## Installation

The package can be installed as:

  1. Add not_qwerty123 to your list of dependencies in `mix.exs`:

        def deps do
          [{:not_qwerty123, "~> 1.0"}]
        end

  2. Ensure not_qwerty123 is started before your application:

        def application do
          [applications: [:not_qwerty123]]
        end
