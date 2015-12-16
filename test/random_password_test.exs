defmodule NotQwerty123.RandomPasswordTest do
  use ExUnit.Case, async: true

  import NotQwerty123.RandomPassword
  import NotQwerty123.PasswordStrength

  test "random password length" do
    assert gen_password(8) |> String.length == 8
    assert gen_password(16) |> String.length == 16
    assert gen_password |> String.length == 12
  end

  test "random password too short length" do
    for len <- 1..7 do
      assert_raise ArgumentError, "The password should be at least 8 characters long.", fn ->
        gen_password(len)
      end
    end
  end

  test "stong password generated" do
    assert gen_password |> strong_password? == true
  end

end
