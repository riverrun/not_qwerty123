defmodule NotQwerty123.GuessableTest do
  use ExUnit.Case, async: true

  import NotQwerty123.Guessable

  test "easy to guess passwords" do
    for id <- ["password", "qwertyuiop", "excalibur"] do
      assert easy_guess?(id) == true
    end
  end

  test "easy to guess passwords with uppercase letters" do
    for id <- ["aSSaSsin", "DolPHIns", "sTaRwArS"] do
      assert easy_guess?(id) == true
    end
  end

  test "easy to guess passwords with substitutions" do
    for id <- ["5(o0byd0o", "qw3r+y12e", "@lpH4!ze"] do
      assert easy_guess?(id) == true
    end
  end

  test "easy to guess passwords with substitutions and an appended letter" do
    for id <- ["aw4nDer3R", "p4vem3n+1", "*m4rip0s@"] do
      assert easy_guess?(id) == true
    end
  end

  test "repeated characters - up to 8 - easy to guess" do
    repeated = ["xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
                "abcabcabcabcabcabcabc", "ababababababababababababababa",
                "abcdabcdabcdabcd", "abcdeabcdeabcdeabcde",
                "abcdefABCDEFabcdefABCDEF",
                "abcdefgABCDEFGabcdefgABCDEFG",
                "abcdefghABCDEFGHabcdefghABCDEFGH"]
    for id <- repeated do
      assert easy_guess?(id) == true
    end
  end

  test "9 repeated characters not easy to guess" do
    assert easy_guess?("abcdefghiabcdefghiabcdefghiabcdefghi") == false
  end

  test "diffifult to guess passwords" do
    for id <- ["8(o0b$d0o", "Gw3r+y12e", "@lT#4z!e"] do
      assert easy_guess?(id) == false
    end
  end

end
