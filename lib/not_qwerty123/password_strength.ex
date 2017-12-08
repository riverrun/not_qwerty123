defmodule NotQwerty123.PasswordStrength do
  @moduledoc """
  Module to check password strength.

  This module does not provide a password strength meter. Instead, it
  simply rejects passwords that are considered too weak. Depending on
  the nature of your application, a solid front end solution to password
  checking, such as [this Dropbox implementation](https://github.com/dropbox/zxcvbn)
  might be a better idea.

  ## Password strength

  In simple terms, password strength depends on how long a password is
  and how easy it is to guess it. In most cases, passwords should be at
  least 8 characters long, and they should not be similar to common
  passwords, like `password` or `qwerty123`, or consist of repeated
  characters, like `abcabcabcabc`. Dictionary words, common names
  and user-specific words (company name, address, etc.) should also
  be avoided.

  ## Further information

  The [NIST password guidelines](https://pages.nist.gov/800-63-3/sp800-63b.html).

  The [Comeonin wiki](https://github.com/elixircnx/comeonin/wiki)
  also has links to further information about password-related issues.
  """

  import NotQwerty123.Gettext
  alias NotQwerty123.WordlistManager

  @doc """
  Check the strength of the password.

  It returns {:ok, password} or {:error, message}

  The password is checked to make sure that it is not too short, that
  it does not consist of repeated characters (e.g. 'abcabcabcabc') and
  that it is not similar to any word in the common password list.

  See the documentation for NotQwerty123.WordlistManager for
  information about customizing the common password list.

  ## Options

  There is one option:

    * `:min_length` - minimum allowable length of the password
      * default is 8

  """
  def strong_password?(password, opts \\ []) do
    min_len = Keyword.get(opts, :min_length, 8)
    word_len = String.length(password)

    if min_len > word_len do
      {
        :error,
        gettext(
          "The password should be at least %{min_len} " <> "characters long.",
          min_len: min_len
        )
      }
    else
      easy_guess?(password, word_len) |> result
    end
  end

  defp easy_guess?(password, word_len) when word_len < 1025 do
    key = String.downcase(password)

    Regex.match?(~r/^.?(..?.?.?.?.?.?.?)(\1+).?$/, key) or WordlistManager.query(key, word_len) or
      password
  end

  defp easy_guess?(password, _), do: password

  defp result(true) do
    {
      :error,
      gettext(
        "The password you have chosen is weak because it is " <>
          "easy to guess. Please choose another one."
      )
    }
  end

  defp result({:error, message}), do: {:error, message}
  defp result(password), do: {:ok, password}
end
