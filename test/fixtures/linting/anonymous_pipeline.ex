defmodule AnonymousPipeline do
  @sentence_start "Start:"

  def bad_pipeline(sentence) do
    sentence
    |> String.split(~r/\s/)
    |> (fn words -> [@sentence_start | words] end).()
    |> Enum.join(" ")
  end
end
