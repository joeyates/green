defmodule ExCop.Lexmag.ElixirStyleGuideFormatter do
  alias ExCop.Cops.{Exceptions, Linting, Modules, Naming, Structs}

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
      |> Linting.NoUnlessWithElse.apply(opts)
      |> Linting.NoNilElse.apply(opts)
      |> Linting.TrueInCond.apply(opts)
      |> Linting.UseStringConcatenationWhenMatchingBinaries.apply(opts)
      |> Naming.AvoidCaps.apply(opts)
      |> Naming.AvoidOneLetterVariables.apply(opts)
      |> Modules.SortReferences.apply(opts)
      |> Modules.UseModulePseudoVariable.apply(opts)
      |> Structs.RemoveNilFromStructDefinition.apply(opts)
      |> Exceptions.UseErrorSuffix.apply(opts)
      |> default_format(opts)

    [formatted, ?\n] |> IO.iodata_to_binary()
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
