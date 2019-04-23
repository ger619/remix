defmodule Remit.Profile do
  use Ecto.Schema

  # import Ecto.Query, only: [from: 2]
  import Ecto.Changeset

  schema "profile" do
    field :name, :string
    field :slug, :string
    field :type, :string
    field :currency, :string

    timestamps()
  end

  @doc false
  def changeset(profile, attrs \\ %{}) do
    profile
    |> cast(attrs, [:name, :type, :currency])
    |> validate_required([:name, :type, :currency])
    |> process_slug
  end

  # Slug check on name
  defp process_slug(changeset) do
    if name = get_change(changeset, :name) do
      slug = Slugger.slugify_downcase(name)
      put_change(changeset, :slug, slug)
    else
      changeset
    end
  end
end
