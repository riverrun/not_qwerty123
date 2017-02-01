defmodule NotQwerty123.I18nTest do
  use ExUnit.Case

  import NotQwerty123.PasswordStrength

  test "gettext returns English message for default locale" do
  end

  test "gettext returns Japanese message if locale is ja_JP" do
    Gettext.put_locale(NotQwerty123.Gettext, "ja_JP")

    assert strong_password?("short") ==
    "パスワードは8文字以上である必要があります。"

    assert strong_password?("p@55W0rD") ==
    "入力されたパスワードは推測が容易で強度が不十分です。違うものを指定してください。"
  end

  test "gettext returns French message if locale is fr_FR" do
    Gettext.put_locale(NotQwerty123.Gettext, "fr_FR")

    assert strong_password?("short") ==
    "Le mot de passe doit contenir au moins 8 caractères."
  end

  test "gettext returns German message if locale is de_DE" do
    Gettext.put_locale(NotQwerty123.Gettext, "de_DE")

    assert strong_password?("short") ==
    "Das Kennwort sollte mindestens 8 Zeichen lang sein."
  end

  test "gettext returns Russian message if locale is ru_RU" do
    Gettext.put_locale(NotQwerty123.Gettext, "ru_RU")

    assert strong_password?("short") ==
    "Минимально допустимая длина пароля составляет 8."
  end

  test "gettext returns Spanish message if locale is es_ES" do
    Gettext.put_locale(NotQwerty123.Gettext, "es_ES")

    assert strong_password?("short") ==
      "La clave debe contener al menos 8 caracteres."
  end

end
