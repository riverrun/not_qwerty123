defmodule NotQwerty123.WordlistManager do
  @moduledoc """
  Module to manage the common password list and handle password checks.

  The main function that NotQwerty123 performs is to check that the
  password, and several transformations of the password, is not in
  the list of common passwords that this WordlistManager stores.

  By default, this common password list contains one file, which
  is a list of over 40,000 common passwords in it. This provides
  a good basis for the password check, but it can also be useful
  to add other words to this list, especially words associated
  with the site you are managing.

  ## Managing the common password list

  The following functions can be used to manage this list:

    * list_wordlists/0 - list the files used to create the wordlist
    * push/1 - add a file to the wordlist
    * pop/1 - remove a file from the wordlist

  """

  use GenServer

  @sub_dict %{
    "!" => ["i"],
    "@" => ["a"],
    "$" => ["s"],
    "%" => ["x"],
    "(" => ["c"],
    "[" => ["c"],
    "+" => ["t"],
    "|" => ["i", "l"],
    "0" => ["o"],
    "1" => ["i", "l"],
    "2" => ["z"],
    "3" => ["e"],
    "4" => ["a"],
    "5" => ["s"],
    "6" => ["g"],
    "7" => ["t"],
    "8" => ["b"],
    "9" => ["g"]
  }

  def start_link() do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init([]) do
    {:ok, create_list()}
  end

  @doc """
  Search the wordlist to see if the password is too common.

  If the password is greater than 24 characters long, this
  function returns false without performing any checks.
  """
  def query(password, word_len) when word_len < 25 do
    GenServer.call(__MODULE__, {:query, password})
  end

  def query(_, _), do: false

  @doc """
  List the files used to create the common password list.
  """
  def list_files, do: GenServer.call(__MODULE__, :list_files)

  @doc """
  Add a file to the common password list.

  `path` is the pathname of the file, which should contain one
  password on each line, that you want to include.

  The file is parsed and the words are added to the common password
  list. A copy of the file is also copied to the
  not_qwerty123/priv/wordlists directory.

  If adding the file results in a timeout error, try splitting
  the file into smaller files and adding them.
  """
  def push(path), do: GenServer.cast(__MODULE__, {:push, path})

  @doc """
  Remove a file from the common password list.

  `path` is the file name as it is printed out in the `list_files`
  function.
  """
  def pop(path), do: GenServer.cast(__MODULE__, {:pop, path})

  def handle_call({:query, password}, _from, state) do
    {:reply, run_check(state, password), state}
  end

  def handle_call(:list_files, _from, state) do
    {:reply, File.ls!(wordlist_dir()), state}
  end

  def handle_cast({:push, path}, state) do
    new_state =
      case File.read(path) do
        {:ok, words} ->
          Path.join(wordlist_dir(), Path.basename(path)) |> File.write(words)
          add_words(words) |> :sets.union(state)

        _ ->
          state
      end

    {:noreply, new_state}
  end

  def handle_cast({:pop, "common_passwords.txt"}, state) do
    {:noreply, state}
  end

  def handle_cast({:pop, path}, state) do
    new_state =
      case File.rm(Path.join(wordlist_dir(), path)) do
        :ok -> create_list()
        _ -> state
      end

    {:noreply, new_state}
  end

  def handle_info(_msg, state) do
    {:noreply, state}
  end

  defp wordlist_dir(), do: Application.app_dir(:not_qwerty123, ~w(priv wordlists))

  defp create_list do
    File.ls!(wordlist_dir())
    |> Enum.map(
         &(Path.join(wordlist_dir(), &1)
           |> File.read!()
           |> add_words)
       )
    |> :sets.union()
  end

  defp add_words(data) do
    data
    |> String.downcase()
    |> String.split("\n")
    |> Enum.flat_map(&list_alternatives/1)
    |> :sets.from_list()
  end

  defp run_check(wordlist, password) do
    words = list_alternatives(password)

    alternatives =
      words ++
        Enum.map(words, &String.slice(&1, 1..-1)) ++
        Enum.map(words, &String.slice(&1, 0..-2)) ++ Enum.map(words, &String.slice(&1, 1..-2))

    reversed = Enum.map(alternatives, &String.reverse(&1))
    Enum.any?(alternatives ++ reversed, &:sets.is_element(&1, wordlist))
  end

  defp list_alternatives(""), do: [""]

  defp list_alternatives(password) do
    for i <- substitute(password) |> product, do: Enum.join(i)
  end

  defp substitute(word) do
    for <<letter <- word>>, do: Map.get(@sub_dict, <<letter>>, [<<letter>>])
  end

  defp product([h]), do: for(i <- h, do: [i])

  defp product([h | t]) do
    for i <- h,
        j <- product(t),
        do: [i | j]
  end
end
