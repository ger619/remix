defmodule RemitWeb.UserView do
  use RemitWeb, :view
  use Scrivener.HTML


  def id_type_for_select(id_types) do
     id_types |> Enum.map(fn type -> {type.name, type.slug} end)
  end
end
