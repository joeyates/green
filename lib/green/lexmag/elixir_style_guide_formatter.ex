defmodule Green.Lexmag.ElixirStyleGuideFormatter do
  @moduledoc """
  ## Usage

  Add the following to your `mix.exs`:

  ```elixir
  defp deps do
    [
      {:green, "~> VERSION"}
    ]
  end
  ```

  Check the latest version of Green on [Hex.pm](https://hex.pm/packages/green).

  Modify `.formatter.exs` to activate the formatter plugin:

  ```elixir
  [
    plugins: [Green.Lexmag.ElixirStyleGuideFormatter]
  ]
  ```

  ## Status of rules

  The implemented rules are marked with a check `✅`.

  When it is possible to transform the code to match the style guide, Green will
  do so.

  When automatic transformation is not possible, Green will
  leave the code as it is and print a warning. These are marked with an
  exclamation mark `❗`.

  Rules that are not implemented are marked with a question mark `❔`. This
  includes rules where there is no way to objectively judge them, such as
  usefulness of comments.

  Rules that are implemented by the compiler or `mix format` are marked with
  a thumbs up `👍`.

  ### Linting

  ✅  Transform nested function calls into pipelines ([Source](https://github.com/lexmag/elixir-style-guide#pipeline-operator),
  [Configuration](Green.Rules.Linting.PreferPipelines.html)).

  ✅ Transform one-element pipelines into function calls ([Source](https://github.com/lexmag/elixir-style-guide#needless-pipeline)),

  ❔ Don't use anonymous functions in pipelines ([Source](https://github.com/lexmag/elixir-style-guide#anonymous-pipeline)),

  ✅ Transform `unless...else...` into `if...else...` ([Source](https://github.com/lexmag/elixir-style-guide#no-else-with-unless)),

  ✅ Transform `if...else nil` into `if...` ([Source](https://github.com/lexmag/elixir-style-guide#no-nil-else)),

  ✅ Ensure match-all condition of `cond` has `true` ([Source](https://github.com/lexmag/elixir-style-guide#true-in-cond)),

  ❔ Use `and` and `or` instead of `&&` and `||` when the arguments are boolean ([Source](https://github.com/lexmag/elixir-style-guide#boolean-operators)),

  ✅ Use `<>` instead of bitstrings when pattern-matching binaries ([Source](https://github.com/lexmag/elixir-style-guide#patterns-matching-binaries)).

  ### Naming

  ❗ Enforce snake_case for atoms, functions, variables, attributes ([Source](https://github.com/lexmag/elixir-style-guide#snake-case-atoms-funs-vars-attrs),
  [Configuration](Green.Rules.Naming.AvoidCaps.html)),

  👍 Enforce CamelCase for modules ([Source](https://github.com/lexmag/elixir-style-guide#camelcase-modules)),

  ❔ Enforce predicate functions to end with a question mark ([Source](https://github.com/lexmag/elixir-style-guide#predicate-funs-names)),

  ✅ Enforce snake_case for directories and files ([Source](https://github.com/lexmag/elixir-style-guide#snake-case-dirs-files)),

  ❗ Disallow one-letter variable names ([Source](https://github.com/lexmag/elixir-style-guide#one-letter-var)).

  ### Comments

  ❔ Use only critical comments ([Source](https://github.com/lexmag/elixir-style-guide#critical-comments)),

  ❔ Avoid superfluous comments ([Source](https://github.com/lexmag/elixir-style-guide#no-superfluous-comments)).

  ### Modules

  ✅ Group and order `use`, `import`, `alias` and `require` statements ([Source](https://github.com/lexmag/elixir-style-guide#module-layout)),

  Notes:

  * This transformation does not take into account comments. Any comment before
    or on the same line as a `use`, `import`, `alias` or `require` statement
    will be left where it is.

  ✅ Replace the current module name with `__MODULE__` ([Source](https://github.com/lexmag/elixir-style-guide#current-module-reference)).

  ### Regular Expressions

  ❔ Prefer pattern matching over regular expressions ([Source](https://github.com/lexmag/elixir-style-guide#pattern-matching-over-regexp)),

  ❔ Use non-capturing regular expressions ([Source](https://github.com/lexmag/elixir-style-guide#non-capturing-regexp)).

  ### Structs

  ✅ Don't specify `nil` default values for `defstruct` fields ([Source](https://github.com/lexmag/elixir-style-guide#defstruct-fields-default)).

  ### Exceptions

  ❗ Use `Error` suffix for exception names ([Source](https://github.com/lexmag/elixir-style-guide#exception-naming)),

  ❔ Use non-capitalized error messages (except for Mix error messages) without trailing punctuation ([Source](https://github.com/lexmag/elixir-style-guide#exception-message)).

  ### ExUnit

  ❔ Put the expression being tested by comparison on the left side ([Source](https://github.com/lexmag/elixir-style-guide#exunit-assertion-side)).

  ### Parentheses

  ✅ Parentheses are a must for local or imported zero-arity function calls ([Source](https://github.com/lexmag/elixir-style-guide?tab=readme-ov-file#zero-arity-parens),
  [Configuration](Green.Rules.Parentheses.UseParenthesesWithZeroArityFunctions.html)).
  """

  alias Green.Rules.{Exceptions, Linting, Modules, Naming, Parentheses, Structs}

  @behaviour Mix.Tasks.Format

  @line_length 98

  @impl true
  def features(_opts) do
    [extensions: [".ex", ".exs"]]
  end

  @spec format_file(String.t()) :: String.t()
  def format_file(file) do
    check_file_name!(file)

    file
    |> File.read!()
    |> format(file: file)
  end

  @impl true
  def format(code, opts \\ []) do
    formatted =
      code
      |> parse(opts)
      |> Linting.PreferPipelines.apply(opts)
      |> Linting.AvoidNeedlessPipelines.apply(opts)
      |> Linting.NoAnonymousFunctionsInPipelines.apply(opts)
      |> Linting.NoUnlessWithElse.apply(opts)
      |> Linting.NoNilElse.apply(opts)
      |> Linting.TrueInCond.apply(opts)
      |> Linting.BooleanOperators.apply(opts)
      |> Linting.UseStringConcatenationWhenMatchingBinaries.apply(opts)
      |> Naming.AvoidCaps.apply(opts)
      |> Naming.AvoidOneLetterVariables.apply(opts)
      |> Naming.PredicateFunctions.apply(opts)
      |> Naming.UpperCamelCaseForModules.apply(opts)
      |> Modules.SortReferences.apply(opts)
      |> Modules.UseModulePseudoVariable.apply(opts)
      |> Parentheses.UseParenthesesWithZeroArityFunctions.apply(opts)
      |> Structs.RemoveNilFromStructDefinition.apply(opts)
      |> Exceptions.UseErrorSuffix.apply(opts)
      |> Exceptions.LowercaseExceptionMessages.apply(opts)
      |> Exceptions.NoTrailingPunctuationInExceptionMessages.apply(opts)
      |> default_format(opts)

    IO.iodata_to_binary([formatted, ?\n])
  end

  defp parse(code, opts) do
    to_quoted_opts =
      [
        unescape: false,
        literal_encoder: &{:ok, {:__block__, &2, [&1]}},
        token_metadata: true,
        emit_warnings: false
      ] ++ opts

    Code.string_to_quoted_with_comments!(code, to_quoted_opts)
  end

  defp default_format({forms, comments}, opts) do
    to_algebra_opts = [comments: comments] ++ opts
    doc = Code.Formatter.to_algebra(forms, to_algebra_opts)

    Inspect.Algebra.format(doc, @line_length)
  end

  defp check_file_name!(file) do
    if String.contains?(file, "-") do
      raise ArgumentError, "'-' found in file name '#{file}'"
    end
  end
end
