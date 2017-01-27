defmodule NotQwerty123.PasswordStrengthTest do
  use ExUnit.Case, async: true

  import NotQwerty123.PasswordStrength

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
    for id <- ["5(o0byd0o", "qw3r+y12e", "@lpH4!ze"] do
      assert strong_password?(id) =~ "password you have chosen is weak"
    end
  end

  test "easy to guess passwords with substitutions and an appended letter" do
    for id <- ["aw4nDer3R", "p4vem3n+1", "*m4rip0s@"] do
      assert strong_password?(id) =~ "password you have chosen is weak"
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
      assert strong_password?(id) =~ "password you have chosen is weak"
    end
  end

  test "9 repeated characters not easy to guess" do
    assert strong_password?("abcdefghiabcdefghiabcdefghiabcdefghi") == true
  end

  test "diffifult to guess passwords" do
    for id <- ["8(o0b$d0o", "Gw3r+y12e", "@lT#4z!e"] do
      assert strong_password?(id) == true
    end
  end

end
