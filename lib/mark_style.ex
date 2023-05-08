defmodule MarkStyle do
  alias Earmark.AstTools
  require Logger

  def as_styled(contents, map \\ %{}) do
    case EarmarkParser.as_ast(contents) do
      {:ok, ast, _} ->
        result = transformed(ast, map)
        Earmark.transform(result)

      {:error, _, causes} ->
        Logger.warn("Earmark could not transform to ast, trying to return a result.")
        for {level, _count, message} <- causes do
          Logger.log(level, message)
        end
        {_, result, _} = Earmark.as_html(contents)
        result
    end
  end

  defp transformed([], _map), do: []

  defp transformed(ast, map) do
    Earmark.Transform.map_ast(
      ast,
      fn {tag, attr, children, meta} = ast_node ->
        children = transformed(children, map)

        key =
          try do
            String.to_existing_atom(tag)
          rescue
            _ in ArgumentError ->
              nil
          end

        case Map.fetch(map, key) do
          {:ok, classes} ->
            AstTools.merge_atts_in_node({tag, attr, children, meta}, class: classes)

          :error ->
            ast_node
        end
      end,
      true
    )
  end
end
