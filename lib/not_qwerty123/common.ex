defmodule NotQwerty123.Common do
  @moduledoc """
  Module to check if the password is too common.

  This module has functions to check if the password, or a similar password,
  is in the common passwords list.

  There are also checks on the password with the first letter removed,
  the last letter removed, and both the first and last letters removed.

  """

  import NotQwerty123.Tools

  @common_words get_words() |> :sets.from_list()

  @doc """
  Check to see if the passord is too easy to guess.
  """
  def common_password?(password) do
    key = String.downcase(password)
    Regex.match?(~r/^.?(..?.?.?.?.?.?)(\1+).?$/, key) or
    common_check(key)
  end

  defp common_check(password) do
    words = permute(password)
    (words ++ Enum.map(words, &String.slice(&1, 1..-1))
     ++ Enum.map(words, &String.slice(&1, 0..-2)))
    |> Enum.any?(&:sets.is_element(&1, @common_words))
  end
end
