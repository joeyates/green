defmodule ExCop.TestCase do
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
    end
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

  defp handle_context(context, {:fixture_pair, fixture}) do
    bad = read_fixture("#{fixture}_bad.ex")
    good = read_fixture("#{fixture}.ex")
    Map.merge(context, %{bad: bad, good: good})
  end

  defp handle_context(context, {:example, filename}) do
    example = read_fixture("#{filename}.ex")
    Map.merge(context, %{example: example})
  end

  defp handle_context(context, {:parse, parse}) do
    code = read_fixture("#{parse}.ex")

    to_quoted_opts =
      [
        unescape: false,
        literal_encoder: &{:ok, {:__block__, &2, [&1]}},
        token_metadata: true,
        emit_warnings: false
      ]

    {forms, comments} = Code.string_to_quoted_with_comments!(code, to_quoted_opts)
    Map.merge(context, %{forms: forms, comments: comments})
  end

  defp handle_context(context, _other), do: context
end
