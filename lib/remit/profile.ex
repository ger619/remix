defmodule Remit.Profile do
  use Ecto.Schema

  import Ecto.Changeset

  alias Remit.Repo

  alias Remit.Account.Account

  schema "profiles" do

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
    |> unique_constraint(:name, name: "profiles_slug_index")
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

  def create(params, profile_type) when profile_type in ["user", "business"] do
    changeset =
      changeset(%__MODULE__{}, params)
      |> put_change(:type, profile_type)

    Repo.transaction(
      fn ->
        case Repo.insert(changeset) do
          {:ok, profile} ->
            create_account!(profile)
            profile
          {:error, changeset} ->
            Repo.rollback(changeset)
        end
    end
    )
  end


  defp create_account!(profile) do
    %Account{}
    |> change(profile_id: profile.id)
    |> Account.changeset()
    |> Repo.insert!()


  def update_profile(%__MODULE__{} = profile, params) do
    profile
    |> changeset(params)
    |> Repo.update()
  end
end
