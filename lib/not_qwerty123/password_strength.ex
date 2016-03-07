defmodule NotQwerty123.PasswordStrength do
  @moduledoc """
  Module to check password strength.

  This module does not provide a password strength meter. Instead, it
  simply rejects passwords that are considered too weak. Depending on
  the nature of your application, a front end solution to password
  checking, such as [this Dropbox implementation](https://github.com/dropbox/zxcvbn)
  might be a better idea.

  The `strong_password?` function checks that the password is long enough,
  it contains at least one digit and one punctuation character, and it is
  not similar to any common passwords.

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
  with a certain character set and a certain length would have. The
  larger the character set and the longer the password is, the greater
  the entropy. This is why users are often encouraged to write long
  passwords that contain digits or punctuation characters.

  Entropy is related to password strength, and a password with a higher
  entropy is usually stronger than one with a lower entropy. However,
  even if the entropy is high, a password is weak if its guessability
  is high.

  ## Password strength check

  In this module's `strong_password?` function, the option common
  is meant to keep the guessability low, and the options min_length
  and extra_chars seek to keep the entropy high.

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

  import NotQwerty123.{Common, Gettext, Tools}

  @digits String.codepoints("0123456789")
  @punc String.codepoints(" !#$%&'()*+,-./:;<=>?@[\\]^_{|}~\"")

  @doc """
  Check the strength of the password.

  ## Options

  There are three options:

    * min_length -- minimum allowable length of the password
    * extra_chars -- check for punctuation characters (including spaces) and digits
    * common -- check to see if the password is too common (easy to guess)

  The default value for `min_length` is 8 characters if `extra_chars` is true,
  but 12 characters if `extra_chars` is false. This is because the password
  should be longer if the character set is restricted to upper and lower case
  letters.

  `extra_chars` and `common` are true by default.

  ## Common passwords

  If the password is found in the list of common passwords, then this function
  will return a message saying that it is too weak because it is easy to guess.
  This check will also check variations of the password with some of the
  characters substituted. For example, for the common password `password`,
  the words `P@$5w0Rd`, `p455w0rd`, `pA$sw0rD` (and many others) will also
  be checked.

  The user's password will also be checked with the first and / or last letter
  removed. For example, the words `(p@$swoRd`, `p4ssw0rD3` and `^P455woRd9`
  would also not be allowed as they are too similar to `password`.

  This `common` option now includes a check for single and double-character
  repetitions, such as '000000000000000000000' or 'ababababababababab'.

  ## Examples

  This example will check that the password is at least 8 characters long,
  it contains at least one punctuation character and one digit, and it is
  not similar to any word in the list of common passwords.

      NotQwerty123.PasswordStrength.strong_password?("7Gr$cHs9")

  The following example will check that the password is at least 16 characters
  long and will not check for punctuation characters or digits.

      NotQwerty123.PasswordStrength.strong_password?("verylongpassword", [min_length: 16, extra_chars: false])

  """
  def strong_password?(password, opts \\ []) do
    {min_len, extra_chars, common} = get_opts(opts)
    word_len = String.length(password)
    all_true? [long_enough?(word_len, min_len),
               has_punc_digit?(extra_chars, password),
               not_common?(common, password, word_len)]
  end

  defp get_opts(opts) do
    {min_len, extra_chars} = case Keyword.get(opts, :extra_chars, true) do
                               true -> {Keyword.get(opts, :min_length, 8), true}
                               _ -> {Keyword.get(opts, :min_length, 12), false}
                             end
    {min_len, extra_chars, Keyword.get(opts, :common, true)}
  end

  defp long_enough?(word_len, min_len) when word_len < min_len do
    gettext "The password should be at least %{min_len} characters long.", min_len: min_len
  end
  defp long_enough?(_, _), do: true

  defp has_punc_digit?(true, word) do
    :binary.match(word, @digits) != :nomatch and
    :binary.match(word, @punc) != :nomatch or
    gettext "The password should contain at least one number and one punctuation character."
  end
  defp has_punc_digit?(false, _), do: true

  defp not_common?(true, password, word_len) do
    password |> String.downcase |> common_password?(word_len) and
    gettext("The password you have chosen is weak because it is easy to guess. " <>
      "Please choose another one.") || true
  end
  defp not_common?(false, _, _), do: true
end
