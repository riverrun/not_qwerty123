defmodule NotQwerty123.RandomPassword do
  @moduledoc """
  Module to generate random passwords and check password strength.

  Users are often advised to use random passwords for authentication.
  However, creating truly random passwords is difficult for people to
  do well and is something that computers are usually better at.

  The `gen_password` function generates a random password with letters,
  uppercase and lowercase, and with the option of using digits and / or
  punctuation characters.
  """

  import NotQwerty123.PasswordStrength

  @alpha Enum.concat(?A..?Z, ?a..?z)
  @digits '0123456789'
  @punc '!#$%&\'()*+,-./:;<=>?@[\\]^_{|}~"'
  @alphabet @alpha ++ @digits ++ @punc
  @char_map Enum.map_reduce(@alphabet, 0, fn x, acc ->
    {{acc, x}, acc + 1} end) |> elem(0) |> Enum.into(%{})

  @doc """
  Randomly generate a password.

  The default length of the password is 8 characters and the minimum
  length is 6 characters.

  ## Options

  There are two options:

    * punctuation - include punctuation characters
      * the default is true
    * digits - include digits
      * the default is true
      * setting digits to false automatically sets punctuation to false

  """
  def gen_password(len \\ 8, opts \\ [])
  def gen_password(len, opts) when len > 5 do
    (for val <- rand_numbers(len, opts), do: Map.get(@char_map, val))
    |> to_string() |> ensure_strong(len, opts)
  end
  def gen_password(_, _) do
    raise ArgumentError, message: "The password should be at least 6 characters long."
  end

  defp rand_numbers(len, opts) do
    end_range = case {opts[:digits], opts[:punctuation]} do
      {false, _} -> 52
      {_, false} -> 62
      _ -> 93
    end
    for _ <- 1..len, do: :crypto.rand_uniform(0, end_range)
  end

  defp ensure_strong(password, len, opts) do
    case strong_password?(password) do
      true -> password
      _ -> gen_password(len, opts)
    end
  end
end
