defmodule NotQwerty123.Tools do
  @moduledoc """
  Various tools used by the password strength checker.
  """

  @doc """
  Check to see if all the functions in a list return true.
  """
  defmacro all_true?([h|t]) do
    quote do
      case unquote(h) do
        true -> all_true?(unquote(t))
        message -> message
      end
    end
  end
  defmacro all_true?([]), do: true

  @doc """
  Similar to `&&`, but the expression on the right will only be evaluated
  if the left expression is true.
  """
  defmacro left &&& right do
    quote do
      case unquote(left) do
        true -> unquote(right)
        message -> message
      end
    end
  end

  @doc """
  Create the word map used in the common password strength check.
  """
  def get_words do
    Path.join([__DIR__, "common_passwords", "10k_6chars.txt"])
    |> File.read!() |> String.split("\n") |> create_map()
  end

  @doc """
  Apply a function to every element in a list and return true is any
  of the elements returns true.
  """
  def any?([h|t], fun) do
    if fun.(h), do: h, else: any?(t, fun)
  end
  def any?([], _), do: false

  defp create_map(wordlist) do
    Enum.reduce(wordlist, %{}, fn word, acc -> update_map(acc, word) end)
  end

  defp update_map(map, word) do
    {k, v} = String.split_at(word, 4)
    case Map.fetch(map, k) do
      {:ok, val} -> Map.put(map, k, val ++ [v])
      :error -> Map.put(map, k, [v])
    end
  end
end
