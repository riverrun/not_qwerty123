# NotQwerty123

[![Module Version](https://img.shields.io/hexpm/v/not_qwerty123.svg)](https://hex.pm/packages/not_qwerty123)
[![Hex Docs](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/not_qwerty123/)
[![Total Download](https://img.shields.io/hexpm/dt/not_qwerty123.svg)](https://hex.pm/packages/not_qwerty123)
[![License](https://img.shields.io/hexpm/l/not_qwerty123.svg)](https://github.com/riverrun/not_qwerty123/blob/master/LICENSE.md)
[![Last Updated](https://img.shields.io/github/last-commit/riverrun/not_qwerty123.svg)](https://github.com/riverrun/not_qwerty123/commits/master)

Elixir library to check password strength and generate random passwords.

The `NotQwerty123.PasswordStrength` module provides checks that the
password is not too easy to guess. These checks check that the password
is long enough and that it is not similar to any common passwords.

The `NotQwerty123.RandomPassword` module generates a random password
with letters, digits and punctuation characters.

## Installation

Make sure you are using Elixir 1.4 or above.

The package can be installed as:

Add `:not_qwerty123` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:not_qwerty123, "~> 2.2"}
  ]
end
```

If updating a pre-Elixir 1.4 app, make sure you change:

```elixir
def application do
  [
    applications: [:logger]
  ]
end
```

to:

```elixir
def application do
  [
    extra_applications: [:logger]
  ]
end
```

or add `:not_qwerty123` to the `applications` list.

See [Elixir 1.4 release notes](http://elixir-lang.org/blog/2017/01/05/elixir-v1-4-0-released/#application-inference) for details.

## Contributing

There are many ways you can contribute to the development of this library, including:

* Reporting issues
* Improving documentation
* Sharing your experiences with others
* [Making a financial contribution](#donations)

## Donations

First of all, I would like to emphasize that this software is offered
free of charge. However, if you find it useful, and you would like to
buy me a cup of coffee, you can do so at [paypal](https://www.paypal.me/alovedalongthe).

## Copyright and License

Copyright (c) 2017 David Whitlock (alovedalongthe@gmail.com)

This software is licensed under [the BSD-3-Clause license](./LICENSE.md).
