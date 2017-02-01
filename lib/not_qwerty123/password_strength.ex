defmodule NotQwerty123.PasswordStrength do
  @moduledoc """
  Module to check password strength.

  This module does not provide a password strength meter. Instead, it
  simply rejects passwords that are considered too weak. Depending on
  the nature of your application, a solid front end solution to password
  checking, such as [this Dropbox implementation](https://github.com/dropbox/zxcvbn)
  might be a better idea.

  # Password security and usability

  The following two sections will provide information about password strength
  and user attitudes to password guidelines.

  If you are checking password strength and not allowing passwords because
  they are too weak, then you need to take the users' attitudes into account.
  If the users find the process of creating passwords too difficult, they
  are likely to find ways of bending the rules you set, and this might have
  a negative impact on password security.

  ## Password strength

  This section will look at how `guessability` and `entropy` relate to
  password strength.

  Guessability is how easy it is for a potential attacker to guess or
  work out what the password is. An attacker is likely to start an
  attempt to guess a password by using common words and common patterns,
  like sequences of characters or repeated characters. A password is strong
  if its guessability is low, that is, if it does not contain such predictable
  patterns.

  Entropy refers to the number of combinations that a password
  with a certain character set and a certain length would have. In
  simple terms, the longer the password is, the greater the entropy.

  Entropy is related to password strength, and a password with a higher
  entropy is usually stronger than one with a lower entropy. However,
  even if the entropy is high, a password is weak if its guessability
  is high.

  ## User attitudes and password security

  It is becoming more and more impractical for users to remember the
  many passwords they need, especially as it is recommended that they
  use a different, strong (often difficult to remember) password for
  each service. As a result, it is likely that many users will choose
  to either use the same password for many services, or use weaker,
  easy to remember passwords.

  One solution to this problem is to have users write down their
  passwords. The obvious problem with this solution is that the
  password can be stolen. It is therefore important that the user
  keeps the password in a safe place and treats its loss seriously.

  Another solution is for the users to use password managers.
  This is a valid solution as long as the password managers themselves
  are secure. See
  [Security of password managers](https://www.schneier.com/blog/archives/2014/09/security_of_pas.html)
  for more information.

  ## Further information

  Visit the [Comeonin wiki](https://github.com/elixircnx/comeonin/wiki)
  for links to further information about these and related issues.

  """

  import NotQwerty123.Gettext
  alias NotQwerty123.WordlistManager

  @doc """
  Check the strength of the password.

  ## Options

  There is one option:

    * min_length -- minimum allowable length of the password
      * default is 8

  """
  def strong_password?(password, opts \\ []) do
    min_len = Keyword.get(opts, :min_length, 8)
    case long_enough?(String.length(password), min_len) do
      true ->
        easy_guess?(password) and
        gettext("The password you have chosen is weak because it is easy to guess. " <>
                "Please choose another one.") || true
        message -> message
    end
  end

  defp long_enough?(word_len, min_len) when word_len < min_len do
    gettext "The password should be at least %{min_len} characters long.", min_len: min_len
  end
  defp long_enough?(_, _), do: true

  defp easy_guess?(password) do
    key = String.downcase(password)
    Regex.match?(~r/^.?(..?.?.?.?.?.?.?)(\1+).?$/, key) or
    WordlistManager.query(key)
  end
end
