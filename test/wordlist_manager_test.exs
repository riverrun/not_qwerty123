defmodule NotQwerty123.WordlistManagerTest do
  use ExUnit.Case

  alias NotQwerty123.WordlistManager, as: WM

  @new_words Path.expand("support/extra_wordlist.txt", __DIR__)

  test "all wordlist files added to state" do
    assert WM.query("p@$$w0rd", 8) == true
    assert WM.query("p@$$w0rd123", 11) == true
  end

  test "long passwords (> 24 chars) always return false" do
    password = String.duplicate("password", 3) <> "p"
    assert WM.query(password, 25) == false
  end

  test "can add new wordlist to state" do
    assert WM.query("sparebutton", 11) == false
    WM.push(@new_words)
    assert WM.query("p@$$w0rd", 8) == true
    assert WM.query("sparebutton", 11) == true
  after
    WM.pop("extra_wordlist.txt")
  end

  test "can remove wordlist from state" do
    WM.push(@new_words)
    assert WM.query("sparebutton", 11) == true
    WM.pop("extra_wordlist.txt")
    assert WM.query("pa$$w0rd", 8) == true
    assert WM.query("sparebutton", 11) == false
  end

  test "list wordlists" do
    assert WM.list_files() == ["common_passwords.txt"]
    WM.push(@new_words)
    WM.list_files() == ["common_passwords.txt", "extra_wordlist.txt"]
  after
    WM.pop("extra_wordlist.txt")
  end

  test "cannot remove default password list" do
    WM.pop("common_passwords.txt")
    assert WM.list_files() == ["common_passwords.txt"]
  end
end
