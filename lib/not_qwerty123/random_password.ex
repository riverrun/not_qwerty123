defmodule NotQwerty123.RandomPassword do
  @moduledoc """
  Module to generate random passwords and check password strength.

  The `gen_password` function generates a random password with letters,
  digits and punctuation characters.
  """

  import NotQwerty123.PasswordStrength

  @alpha Enum.concat ?A..?Z, ?a..?z
  @alphabet '!#$%&\'()*+,-./:;<=>?@[\\]^_{|}~"' ++ @alpha ++ '0123456789'
  @char_map Enum.map_reduce(@alphabet, 0, fn x, acc ->
    {{acc, x}, acc + 1} end) |> elem(0) |> Enum.into(%{})

  @doc """
  Randomly generate a password.

  Users are often advised to use random passwords for authentication.
  However, creating truly random passwords is difficult for people to
  do well and is something that computers are usually better at.

  This function creates a random password that is guaranteed to contain
  at least one digit and one punctuation character.

  The default length of the password is 12 characters and the minimum
  length is 8 characters.
  """
  def gen_password(len \\ 12)
  def gen_password(len) when len > 7 do
    rand_password(len) |> to_string |> ensure_strong(len)
  end
  def gen_password(_) do
    raise ArgumentError, message: "The password should be at least 8 characters long."
  end

  defp rand_password(len) do
    case rand_numbers(len) |> punc_digit? do
      false -> rand_password(len)
      code -> for val <- code, do: Map.get(@char_map, val)
    end
  end
  defp rand_numbers(len) do
    for _ <- 1..len, do: :crypto.rand_uniform(0, 93)
  end
  defp punc_digit?(code) do
    Enum.any?(code, &(&1 < 31)) and Enum.any?(code, &(&1 > 82)) and code
  end

  defp ensure_strong(password, len) do
    case strong_password?(password) do
      true -> password
      _ -> gen_password(len)
    end
  end

end
