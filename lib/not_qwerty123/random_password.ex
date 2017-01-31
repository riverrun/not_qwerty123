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

  ## Options

  There are two options:

    * length - length of the password, in characters
      * the default is 8
      * the minimum length is 6
    * characters - the character set - `:letters`, `:letters_digits` or `:letters_digits_punc`
      * `:letters` will just use uppercase and lowercase letters in the password
      * `:letters_digits` will use letters and digits
      * `:letters_digits_punc` will use letters, digits and punctuation characters
      * the default is `:letters_digits_punc`

  """
  def gen_password(opts \\ [])
  def gen_password(opts) do
    {len, chars} = {Keyword.get(opts, :length, 8),
      Keyword.get(opts, :characters, :letters_digits_punc)}
    (for val <- rand_numbers(len, chars), do: Map.get(@char_map, val))
    |> to_string() |> ensure_strong(opts)
  end

  defp rand_numbers(len, chars) when len > 5 do
    end_range = case chars do
      :letters -> 52
      :letters_digits -> 62
      _ -> 93
    end
    for _ <- 1..len, do: :crypto.rand_uniform(0, end_range)
  end
  defp rand_numbers(_, _) do
    raise ArgumentError, message: "The password should be at least 6 characters long."
  end

  defp ensure_strong(password, opts) do
    case strong_password?(password) do
      true -> password
      _ -> gen_password(opts)
    end
  end
end
