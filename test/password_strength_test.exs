defmodule NotQwerty123.PasswordStrengthTest do
  use ExUnit.Case

  import NotQwerty123.PasswordStrength

  defp read_file(filename) do
    Path.expand("support/#{filename}.txt", __DIR__)
    |> File.read!()
    |> String.split("\n", trim: true)
  end

  describe "password length" do
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
  end

  describe "character repetitions" do
    test "repeated characters" do
      for id <- [
            "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
            "abcabcabcabcabcabcabc",
            "abcdabcdabcdabcd",
            "abcdeabcdeabcdeabcde",
            "abcdefABCDEFabcdefABCDEF"
          ] do
        {:error, message} = strong_password?(id)
        assert message =~ "password you have chosen is weak"
      end
    end

    test "repeated characters with extra first or last letter" do
      for id <- [
            "1xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
            "abcabcabcabcabcabcabc9",
            "5abcdabcdabcdabcd",
            "abcdeabcdeabcdeabcde7",
            "3abcdefABCDEFabcdefABCDEF8"
          ] do
        {:error, message} = strong_password?(id)
        assert message =~ "password you have chosen is weak"
      end
    end

    test "for long repetitions, only returns error when capture is common" do
      for id <- [
            "qwertyuiopQWERTYUIOPqwertyuiop",
            "internetINTERNETinternet",
            "passwordPASSWORDpasswordPASSWORD"
          ] do
        {:error, message} = strong_password?(id)
        assert message =~ "password you have chosen is weak"
      end

      for id <- [
            "xkoVEhsExkoVEhsExkoVEhsE",
            "MA9sSGHdMA9sSGHdMA9sSGHd",
            "2K5jcNUA2K5jcNUA2K5jcNUA"
          ] do
        {:ok, password} = strong_password?(id)
        assert password == id
      end
    end

    test "not repeated characters - should return password" do
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

    test "very long passwords (> 128 chars) are not checked for repetitions" do
      password = String.duplicate("password", 16)
      {:error, message} = strong_password?(password)
      assert message =~ "password you have chosen is weak"
      password = String.duplicate("password", 17)
      assert {:ok, _} = strong_password?(password)
    end
  end

  describe "common passwords" do
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

    test "easy to guess passwords with substitutions and a prepended letter" do
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
  end

  describe "strong passwords" do
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
end
