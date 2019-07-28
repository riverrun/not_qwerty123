Benchee.run(
  %{
    "wordlist_query" => fn password -> NotQwerty123.WordlistManager.query(password, String.length(password)) end,
    "password_strength_check" => fn password -> NotQwerty123.PasswordStrength.strong_password?(password) end
  },
  inputs: %{
    "short common" => "p@$$w0rd",
    "medium common" => "p@$$w0rdP@$$W0RD",
    "long common" => "p@$$w0rdP@$$W0RDp@$$w0rd",
    "short random" => "vStgoiMx",
    "medium random" => "OMUdEUe6B1DDgDgj",
    "long random" => "wGtArhGWYhacS71dAzE94pdt"
  },
  memory_time: 2
)
