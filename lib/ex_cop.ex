defmodule ExCop do
  alias ExCop.Cops.{Linting, Modules, Naming}

  @line_length 98

  @spec format_file(String.t()) :: String.t()
  def format_file(file) do
    check_file_name!(file)

    file
    |> File.read!()
    |> format_string(file: file)
  end

  @spec format_string(String.t()) :: String.t()
  def format_string(code, opts \\ []) do
    formatted =
      code
      |> parse(opts)
      |> Linting.PreferPipelines.apply()
      |> Linting.AvoidNeedlessPipelines.apply()
      |> Linting.NoUnlessWithElse.apply()
      |> Linting.NoNilElse.apply()
      |> Linting.TrueInCond.apply()
      |> Linting.UseStringConcatenationWhenMatchingBinaries.apply()
      |> Naming.AvoidCaps.apply()
      |> Modules.SortReferences.apply()
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
