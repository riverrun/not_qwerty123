defmodule NotQwerty123.WordlistManagerTest do
  use ExUnit.Case

  alias NotQwerty123.WordlistManager, as: WM

  @new_words Path.expand("support/extra_wordlist.txt", __DIR__)
  @wordlist_dir Path.join(Application.app_dir(:not_qwerty123, "priv"), "wordlists")

  test "all wordlist files added to state" do
    assert WM.query("p@$$w0rd") == true
    assert WM.query("p@$$w0rd123") == true
  end

  test "can add new wordlist to state" do
    assert WM.query("sparebutton") == false
    WM.push @new_words
    assert WM.query("p@$$w0rd") == true
    assert WM.query("sparebutton") == true
  after
    File.rm(Path.join(@wordlist_dir, "extra_wordlist.txt"))
  end

  test "can remove wordlist from state" do
    WM.push @new_words
    assert WM.query("sparebutton") == true
    WM.pop "extra_wordlist.txt"
    assert WM.query("pa$$w0rd") == true
    assert WM.query("sparebutton") == false
  after
    File.rm(Path.join(@wordlist_dir, "extra_wordlist.txt"))
  end

  test "list wordlists" do
    assert WM.list_files == ["common_passwords.txt"]
    WM.push @new_words
    WM.list_files == ["common_passwords.txt", "extra_wordlist.txt"]
  after
    File.rm(Path.join(@wordlist_dir, "extra_wordlist.txt"))
  end

end
