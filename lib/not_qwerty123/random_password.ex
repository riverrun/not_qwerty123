defmodule NotQwerty123.RandomPassword do
  @moduledoc """
  Module to generate random passwords.

  Users are often advised to use random passwords for authentication.
  However, creating truly random passwords is difficult for people to
  do well and is something that computers are usually better at.

  This module provides the `gen_password` function, which generates
  a random password.
  """

  import NotQwerty123.PasswordStrength

  @alpha Enum.concat(?A..?Z, ?a..?z)
  @digits '0123456789'
  @punc '!#$%&\'()*+,-./:;<=>?@[\\]^_{|}~"'
  @alphabet @alpha ++ @digits ++ @punc
  @char_map Enum.map_reduce(@alphabet, 0, fn x, acc ->
              {{acc, x}, acc + 1}
            end)
            |> elem(0)
            |> Enum.into(%{})

  @doc """
  Generate a random password.

  ## Options

  There are two options:

    * `:length` - length of the password, in characters
      * the default is 8
      * the minimum length is 6
    * `:characters` - the character set - `:letters`, `:letters_digits` or `:letters_digits_punc`
      * the default is `:letters_digits`, which will use letters and digits in the password
      * `:digits` will only use digits
      * `:letters` will use uppercase and lowercase letters
      * `:letters_digits_punc` will use letters, digits and punctuation characters

  """
  def gen_password(opts \\ []) do
    {len, chars} =
      {Keyword.get(opts, :length, 8), Keyword.get(opts, :characters, :letters_digits)}

    for(val <- rand_numbers(len, chars), do: Map.get(@char_map, val))
    |> to_string()
    |> ensure_strong(opts)
  end

  defp rand_numbers(len, chars) when len > 5 do
    {start_range, end_range} =
      case chars do
        :digits -> {52, 62}
        :letters -> {0, 52}
        :letters_digits_punc -> {0, 93}
        _ -> {0, 62}
      end

    :crypto.rand_seed()
    for _ <- 1..len, do: Enum.random(start_range..(end_range - 1))
  end

  defp rand_numbers(_, _) do
    raise ArgumentError, message: "The password should be at least 6 characters long."
  end

  defp ensure_strong(password, opts) do
    case strong_password?(password) do
      {:ok, password} -> password
      _ -> gen_password(opts)
    end
  end
end
