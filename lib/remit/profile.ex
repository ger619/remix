defmodule Remit.Profile do
  use Ecto.Schema

  import Ecto.Changeset

  alias Remit.Repo
  alias Remit.Account.Account

  schema "profile" do
    field :name, :string
    field :slug, :string
    field :type, :string
    field :currency, :string

    timestamps()
  end
  What
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

  def create(business) do

    %__MODULE__{}

    Repo.transaction(fn ->
      case Repo.insert(changeset(%__MODULE__{}, business)) do
        {:ok, profile} ->
          profile

          |> create_account()

        {:error, changeset} ->
          Repo.rollback(changeset)
      end
    end)

  end

  defp create_account(params) do
    %__MODULE__{}
    |> Account.changeset(params)
    |> Repo.insert()
  end

  def update_profile(%__MODULE__{} = profile, params) do
    profile
    |> changeset(params)
    |> Repo.update()
  end


end
