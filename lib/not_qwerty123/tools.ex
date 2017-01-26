defmodule NotQwerty123.Tools do
  @moduledoc """
  Various tools used by the password strength checker.
  """

  @sub_dict %{
    "!" => ["i"], "@" => ["a"], "$" => ["s"],
    "%" => ["x"], "(" => ["c"], "[" => ["c"],
    "+" => ["t"], "|" => ["i", "l"],
    "0" => ["o"], "1" => ["i", "l"], "2" => ["z"],
    "3" => ["e"], "4" => ["a"], "5" => ["s"],
    "6" => ["g"], "7" => ["t"], "8" => ["b"],
    "9" => ["g"]
  }

  @doc """
  Create the word list used to test the guessability of a password.
  """
  def get_words do
    Path.join([__DIR__, "wordlists", "10k_6chars.txt"])
    |> File.read!
    |> String.downcase
    |> String.split("\n")
    |> Enum.flat_map(&permute/1)
  end

  @doc """
  """
  def permute(""), do: [""]
  def permute(password) do
    for i <- substitute(password) |> product, do: Enum.join(i)
  end

  defp substitute(word) do
    for <<letter <- word>>, do: Map.get(@sub_dict, <<letter>>, [<<letter>>])
  end

  defp product([h]), do: (for i <- h, do: [i])
  defp product([h|t]) do
    for i <- h, j <- product(t), do: [i|j]
  end
end
