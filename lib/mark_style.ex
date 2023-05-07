defmodule MarkStyle do
  alias Earmark.AstTools

  def as_styled(contents, map \\ %{}) do
    {:ok, ast, _} = EarmarkParser.as_ast(contents)
    result = transformed(ast, map)
    Earmark.transform(result)
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
            _ in ArgumentError -> nil
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

