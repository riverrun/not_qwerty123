defmodule NotQwerty123.Mixfile do
  use Mix.Project

  @version "2.2.1"

  @description """
  Library to check password strength and generate random passwords.
  """

  def project do
    [
      app: :not_qwerty123,
      version: @version,
      elixir: "~> 1.4",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      name: "NotQwerty123",
      description: @description,
      package: package(),
      source_url: "https://github.com/riverrun/not_qwerty123",
      compilers: [:gettext] ++ Mix.compilers(),
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {NotQwerty123, []}
    ]
  end

  defp deps do
    [
      {:gettext, "~> 0.13"},
      {:ex_doc, "~> 0.18", only: :dev, runtime: false}
    ]
  end

  defp package do
    [
      maintainers: ["David Whitlock"],
      licenses: ["BSD"],
      links: %{"GitHub" => "https://github.com/riverrun/not_qwerty123"}
    ]
  end
end
