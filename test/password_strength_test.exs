defmodule NotQwerty123.PasswordStrengthTest do
  use ExUnit.Case

  import NotQwerty123.PasswordStrength

  defp read_file(filename) do
    Path.expand("support/#{filename}.txt", __DIR__)
    |> File.read!
    |> String.split("\n", trim: true)
  end

  test "password default minimum length" do
    assert strong_password?("4ghY&j23") == true
    assert strong_password?("4ghY&j2") ==
    "The password should be at least 8 characters long."
  end

  test "password minimum length config" do
    assert strong_password?("4ghY&j2", [min_length: 6]) == true
    assert strong_password?("4ghY&j2", [min_length: 8]) ==
    "The password should be at least 8 characters long."
  end

  test "easy to guess passwords" do
    for id <- ["password", "qwertyuiop", "excalibur"] do
      assert strong_password?(id) =~ "password you have chosen is weak"
    end
  end

  test "easy to guess passwords with uppercase letters" do
    for id <- ["aSSaSsin", "DolPHIns", "sTaRwArS"] do
      assert strong_password?(id) =~ "password you have chosen is weak"
    end
  end

  test "easy to guess passwords with substitutions" do
    for id <- read_file("substitutions") do
      assert strong_password?(id, min_length: 6) =~ "password you have chosen is weak"
    end
  end

  test "easy to guess passwords with substitutions and an prepended letter" do
    for id <- read_file("prepend") do
      assert strong_password?(id, min_length: 6) =~ "password you have chosen is weak"
    end
  end

  test "easy to guess passwords with substitutions and an appended letter" do
    for id <- read_file("append") do
      assert strong_password?(id, min_length: 6) =~ "password you have chosen is weak"
    end
  end

  test "easy to guess passwords with substitutions and letters added to start and end" do
    for id <- read_file("preappend") do
      assert strong_password?(id, min_length: 6) =~ "password you have chosen is weak"
    end
  end

  test "easy to guess reversed passwords with substitutions" do
    for id <- read_file("reversed") do
      assert strong_password?(id, min_length: 6) =~ "password you have chosen is weak"
    end
  end

  test "repeated characters easy to guess" do
    for id <- ["xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
               "abcabcabcabcabcabcabc",
               "abcdabcdabcdabcd",
               "abcdeabcdeabcdeabcde",
               "abcdefABCDEFabcdefABCDEF",
               "abcdefgABCDEFGabcdefgABCDEFG",
               "abcdefghABCDEFGHabcdefghABCDEFGH",
               "abcabcabcabcabcabca",
               "abcdeabcdeabcdeab"
             ], do: assert strong_password?(id) =~ "password you have chosen is weak"
  end

  test "not repeated characters - should return true" do
    for id <- ["abcabcacbabcabcabcabc",
               "abababababaabbabababababababa",
               "abcdabcadbcdabcd",
               "abcdeacbdeabcdeabcde",
               "abcdefABCEDFabcdefABCDEF"
             ], do: assert strong_password?(id)
  end

  test "difficult to guess passwords" do
    for id <- read_file("allowed") do
      assert strong_password?(id, min_length: 6) == true
    end
  end

end
