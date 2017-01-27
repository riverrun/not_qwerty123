defmodule NotQwerty123.WordlistManager do
  use GenServer

  @wordlist_path Path.join(Application.app_dir(:not_qwerty123, "priv"), "wordlists")

  @sub_dict %{
    "!" => ["i"], "@" => ["a"], "$" => ["s"],
    "%" => ["x"], "(" => ["c"], "[" => ["c"],
    "+" => ["t"], "|" => ["i", "l"],
    "0" => ["o"], "1" => ["i", "l"], "2" => ["z"],
    "3" => ["e"], "4" => ["a"], "5" => ["s"],
    "6" => ["g"], "7" => ["t"], "8" => ["b"],
    "9" => ["g"]
  }

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init([]) do
    filename = Path.join(@wordlist_path, "10k_6chars.txt")
    state = add_words(filename)
    {:ok, state}
  end

  def get_state(), do: GenServer.call(__MODULE__, :get_state)

  def query_wordlist(password), do: GenServer.call(__MODULE__, {:query, password})

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end
  def handle_call({:query, password}, _from, state) do
    {:reply, run_check(state, password), state}
  end

  def handle_info(_msg, state) do
    {:noreply, state}
  end

  defp add_words(filename) do
    filename
    |> File.read!
    |> String.downcase
    |> String.split("\n")
    |> Enum.flat_map(&list_alternatives/1)
    |> :sets.from_list
  end

  defp run_check(wordlist, password) do
    words = list_alternatives(password)
    (words ++ Enum.map(words, &String.slice(&1, 1..-1))
     ++ Enum.map(words, &String.slice(&1, 0..-2))
     ++ Enum.map(words, &String.slice(&1, 1..-2)))
    |> Enum.any?(&:sets.is_element(&1, wordlist))
  end

  defp list_alternatives(""), do: [""]
  defp list_alternatives(password) do
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
