defmodule NotQwerty123.PasswordStrengthTest do
  use ExUnit.Case

  import NotQwerty123.PasswordStrength

  defp read_file(filename) do
    Path.expand("support/#{filename}.txt", __DIR__)
    |> File.read!()
    |> String.split("\n", trim: true)
  end

  test "password default minimum length" do
    {:ok, password} = strong_password?("4ghY&j23")
    assert password == "4ghY&j23"
    {:error, message} = strong_password?("4ghY&j2")
    assert message =~ "password should be at least 8 characters long"
  end

  test "password minimum length config" do
    {:ok, password} = strong_password?("4ghY&j2", min_length: 6)
    assert password == "4ghY&j2"
    {:error, message} = strong_password?("4ghY&j2", min_length: 8)
    assert message =~ "password should be at least 8 characters long"
  end

  test "easy to guess passwords" do
    for id <- ["password", "qwertyuiop", "excalibur"] do
      {:error, message} = strong_password?(id, min_length: 6)
      assert message =~ "password you have chosen is weak"
    end
  end

  test "easy to guess passwords with uppercase letters" do
    for id <- ["aSSaSsin", "DolPHIns", "sTaRwArS"] do
      {:error, message} = strong_password?(id, min_length: 6)
      assert message =~ "password you have chosen is weak"
    end
  end

  test "easy to guess passwords with substitutions" do
    for id <- read_file("substitutions") do
      {:error, message} = strong_password?(id, min_length: 6)
      assert message =~ "password you have chosen is weak"
    end
  end

  test "easy to guess passwords with substitutions and an prepended letter" do
    for id <- read_file("prepend") do
      {:error, message} = strong_password?(id, min_length: 6)
      assert message =~ "password you have chosen is weak"
    end
  end

  test "easy to guess passwords with substitutions and an appended letter" do
    for id <- read_file("append") do
      {:error, message} = strong_password?(id, min_length: 6)
      assert message =~ "password you have chosen is weak"
    end
  end

  test "easy to guess passwords with substitutions and letters added to start and end" do
    for id <- read_file("preappend") do
      {:error, message} = strong_password?(id, min_length: 6)
      assert message =~ "password you have chosen is weak"
    end
  end

  test "easy to guess reversed passwords with substitutions" do
    for id <- read_file("reversed") do
      {:error, message} = strong_password?(id, min_length: 6)
      assert message =~ "password you have chosen is weak"
    end
  end

  test "repeated characters easy to guess" do
    for id <- [
          "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
          "abcabcabcabcabcabcabc",
          "abcdabcdabcdabcd",
          "abcdeabcdeabcdeabcde",
          "abcdefABCDEFabcdefABCDEF",
          "abcdefgABCDEFGabcdefgABCDEFG",
          "abcdefghABCDEFGHabcdefghABCDEFGH",
          "abcabcabcabcabcabca",
          "abcdeabcdeabcdeab"
        ] do
      {:error, message} = strong_password?(id)
      assert message =~ "password you have chosen is weak"
    end
  end

  test "not repeated characters - should return true" do
    for id <- [
          "abcabcacbabcabcabcabc",
          "abababababaabbabababababababa",
          "abcdabcadbcdabcd",
          "abcdeacbdeabcdeabcde",
          "abcdefABCEDFabcdefABCDEF"
        ] do
      {:ok, password} = strong_password?(id)
      assert password == id
    end
  end

  test "very long passwords (> 1024 chars) are not checked for repetitions" do
    password = String.duplicate("password", 120) <> "p"
    {:error, message} = strong_password?(password)
    assert message =~ "password you have chosen is weak"
    password = String.duplicate("password", 128) <> "p"
    assert {:ok, _} = strong_password?(password)
  end

  test "difficult to guess passwords" do
    for id <- read_file("allowed") do
      {:ok, password} = strong_password?(id, min_length: 6)
      assert password == id
    end
  end

  test "randomly generated passwords" do
    for id <- read_file("random") do
      {:ok, password} = strong_password?(id)
      assert password == id
    end
  end
end
