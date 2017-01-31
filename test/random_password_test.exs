defmodule NotQwerty123.RandomPasswordTest do
  use ExUnit.Case, async: true

  import NotQwerty123.RandomPassword

  test "random password length" do
    assert gen_password(length: 8) |> String.length == 8
    assert gen_password(length: 16) |> String.length == 16
    assert gen_password() |> String.length == 8
  end

  test "random password too short length" do
    for len <- 1..5 do
      assert_raise ArgumentError, "The password should be at least 6 characters long.", fn ->
        gen_password(length: len)
      end
    end
  end

  test "random password with letters and digits" do
    for _ <- 1..100 do
      key = gen_password(characters: :letters_digits)
      assert Regex.match?(~r/^[a-zA-Z0-9]*$/, key)
    end
  end

  test "random password with just letters" do
    for _ <- 1..100 do
      key = gen_password(characters: :letters)
      assert Regex.match?(~r/^[a-zA-Z]*$/, key)
    end
  end

  test "random password with just digits" do
    for _ <- 1..100 do
      key = gen_password(characters: :digits)
      assert Regex.match?(~r/^[0-9]*$/, key)
    end
  end

end
