defmodule NotQwerty123.PasswordStrengthTest do
  use ExUnit.Case, async: true

  import NotQwerty123.PasswordStrength

  test "password default minimum length" do
  end

  test "password minimum length config" do
    assert strong_password?("4ghY&j2", [min_length: 6]) == true
    assert strong_password?("4ghY&j2", [min_length: 8]) ==
    "The password should be at least 8 characters long."
  end

end
