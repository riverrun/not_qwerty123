defmodule NotQwerty123 do
  @moduledoc """
  Library to check password strength and generate random passwords.

  The `NotQwerty123.PasswordStrength` module provides checks that the
  password is not too easy to guess. These checks check that the password
  is long enough and that it is not similar to any common passwords.

  The `NotQwerty123.RandomPassword` module generates a random password
  with letters, digits and punctuation characters.

  """

  use Application

  @doc false
  def start(_type, _args) do
    NotQwerty123.Supervisor.start_link()
  end
end
