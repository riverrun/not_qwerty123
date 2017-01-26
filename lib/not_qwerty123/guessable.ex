defmodule NotQwerty123.Guessable do
  @moduledoc """
  Module to check if the password is too easy to guess.
  """

  import NotQwerty123.Tools

  @wordlist get_words() |> :sets.from_list()

  @doc """
  Check to see if the passord is too easy to guess.
  """
  def easy_guess?(password) do
    key = String.downcase(password)
    Regex.match?(~r/^.?(..?.?.?.?.?.?.?)(\1+).?$/, key) or
    run_check(key)
  end

  defp run_check(password) do
    words = permute(password)
    (words ++ Enum.map(words, &String.slice(&1, 1..-1))
     ++ Enum.map(words, &String.slice(&1, 0..-2))
     ++ Enum.map(words, &String.slice(&1, 1..-2)))
    |> Enum.any?(&:sets.is_element(&1, @wordlist))
  end
end
