defmodule NotQwerty123.WordlistManagerTest do
  use ExUnit.Case

  alias NotQwerty123.WordlistManager, as: WM

  @wordlist_path Path.expand("support/extra_wordlist.txt", __DIR__)

  test "all wordlist files added to state" do
    assert WM.query("p@$$w0rd") == true
    assert WM.query("p@$$w0rd123") == true
  end

  test "can add new wordlist to state" do
    assert WM.query("sparebutton") == false
    WM.push @wordlist_path
    assert WM.query("p@$$w0rd") == true
    assert WM.query("sparebutton") == true
  end

end
