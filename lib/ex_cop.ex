defmodule ExCop do
  alias ExCop.Cops.{PreferPipelines, AvoidNeedlessPipelines, SortModuleReferences}

  @line_length 98

  @spec format_file(String.t()) :: String.t()
  def format_file(file) do
    file
    |> File.read!()
    |> format_string(file: file)
  end

  @spec format_string(String.t()) :: String.t()
  def format_string(code, opts \\ []) do
    formatted =
      code
      |> parse(opts)
      |> PreferPipelines.apply()
      |> AvoidNeedlessPipelines.apply()
      |> SortModuleReferences.apply()
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
end
