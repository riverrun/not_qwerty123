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

  It returns `{:ok, password}` or `{:error, message}`.

  The password is checked to make sure that it is not too short, that
  it does not consist of repeated characters (e.g. 'abcabcabcabc') and
  that it is not similar to any word in the common password list.

  See the documentation for `NotQwerty123.WordlistManager` for
  information about customizing the common password list.

  ## Options

  There is only one option:

    * `:min_length` - minimum allowable length of the password
      * default is `8`

  """
  def strong_password?(password, opts \\ []) do
    min_len = Keyword.get(opts, :min_length, 8)
    word_len = String.length(password)

    if min_len > word_len do
      {:error, too_short_error(min_len)}
    else
      if easy_guess?(String.downcase(password), word_len) do
        {:error, easy_guess_error()}
      else
        {:ok, password}
      end
    end
  end

  defp easy_guess?(key, key_len) do
    case repetition_check(key, key_len) do
      nil ->
        WordlistManager.query(key, key_len)

      [_, key] ->
        key_len = String.length(key)
        key_len < 7 or WordlistManager.query(key, key_len)
    end
  end

  defp repetition_check(_, word_len) when word_len > 128, do: nil

  defp repetition_check(word, _) do
    Regex.run(~r/^.?(.+?)\1+.?$/, word)
  end

  defp easy_guess_error do
    gettext(
      "The password you have chosen is weak because it is easy to guess. Please choose another one."
    )
  end

  defp too_short_error(min_len) do
    gettext("The password should be at least %{min_len} characters long.", min_len: min_len)
  end
end
