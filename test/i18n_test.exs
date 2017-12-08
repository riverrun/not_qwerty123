defmodule NotQwerty123.I18nTest do
  use ExUnit.Case

  import NotQwerty123.PasswordStrength

  test "gettext returns English message for default locale" do
    {:error, message} = strong_password?("4ghY&j2")
    assert message =~ "password should be at least 8 characters long"
  end

  test "gettext returns Japanese message if locale is ja_JP" do
    Gettext.put_locale(NotQwerty123.Gettext, "ja_JP")

    {:error, message} = strong_password?("short")
    assert message =~ "パスワードは8文字以上である必要があります。"

    {:error, message} = strong_password?("p@55W0rD")
    assert message =~ "入力されたパスワードは推測が容易で強度が不十分です。違うものを指定してください。"
  end

  test "gettext returns French message if locale is fr_FR" do
    Gettext.put_locale(NotQwerty123.Gettext, "fr_FR")

    {:error, message} = strong_password?("short")
    assert message =~ "Le mot de passe doit contenir au moins 8 caractères."
  end

  test "gettext returns German message if locale is de_DE" do
    Gettext.put_locale(NotQwerty123.Gettext, "de_DE")

    {:error, message} = strong_password?("short")
    assert message =~ "Das Kennwort sollte mindestens 8 Zeichen lang sein."
  end

  test "gettext returns Russian message if locale is ru_RU" do
    Gettext.put_locale(NotQwerty123.Gettext, "ru_RU")

    {:error, message} = strong_password?("short")
    assert message =~ "Минимально допустимая длина пароля составляет 8."
  end

  test "gettext returns Spanish message if locale is es_ES" do
    Gettext.put_locale(NotQwerty123.Gettext, "es_ES")

    {:error, message} = strong_password?("short")
    assert message =~ "La clave debe contener al menos 8 caracteres."
  end
end
