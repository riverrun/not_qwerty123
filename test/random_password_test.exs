defmodule NotQwerty123.RandomPasswordTest do
  use ExUnit.Case, async: true

  import NotQwerty123.RandomPassword

  test "random password length" do
    assert gen_password(8) |> String.length == 8
    assert gen_password(16) |> String.length == 16
    assert gen_password() |> String.length == 8
  end

  test "random password too short length" do
    for len <- 1..5 do
      assert_raise ArgumentError, "The password should be at least 6 characters long.", fn ->
        gen_password(len)
      end
    end
  end

  test "random password with no punctuation characters" do
    for _ <- 1..100 do
      key = gen_password(8, punctuation: false)
      assert Regex.match?(~r/^[a-zA-Z0-9]*$/, key)
    end
  end

  test "random password with no digits or punctuation characters" do
    for _ <- 1..100 do
      key = gen_password(8, digits: false)
      assert Regex.match?(~r/^[a-zA-Z]*$/, key)
    end
  end

end
