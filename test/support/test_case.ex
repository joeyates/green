defmodule Green.TestCase do
  @moduledoc """
  This module provides functions for fixture loading and test case setup.
  """
  use ExUnit.CaseTemplate

  def read_fixture(filename) do
    ["test", "fixtures", filename]
    |> Path.join()
    |> File.read!()
  end

  using(_opts) do
    quote do
      def default_format({forms, comments}) do
        to_algebra_opts = [comments: comments]
        doc = Code.Formatter.to_algebra(forms, to_algebra_opts)

        formatted = Inspect.Algebra.format(doc, 98)
        [formatted, ?\n] |> IO.iodata_to_binary()
      end

      defdelegate parse_code(code), to: Green.TestCase
    end
  end

  def parse_code(code) do
    to_quoted_opts =
      [
        unescape: false,
        literal_encoder: &{:ok, {:__block__, &2, [&1]}},
        token_metadata: true,
        emit_warnings: false
      ]

    Code.string_to_quoted_with_comments!(code, to_quoted_opts)
  end

  setup context do
    context
    |> Enum.reduce(
      context,
      fn
        {key, value}, acc -> handle_context(acc, {key, value})
      end
    )
  end

  defp handle_context(context, {:bad, filename}) do
    bad = read_fixture("#{filename}.ex")
    {forms, comments} = parse_code(bad)
    Map.merge(context, %{bad: bad, bad_forms: forms, bad_comments: comments})
  end

  defp handle_context(context, {:good, filename}) do
    good = read_fixture("#{filename}.ex")
    {forms, comments} = parse_code(good)
    Map.merge(context, %{good: good, good_forms: forms, good_comments: comments})
  end

  defp handle_context(context, _other), do: context
end
