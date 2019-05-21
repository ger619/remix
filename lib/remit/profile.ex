defmodule Remit.Profile do
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]

  alias Remit.Repo
  alias Remit.User

  alias Remit.Account.Account
  alias Remit.UserProfiles

  schema "profiles" do
    field :name, :string
    field :slug, :string
    field :type, :string
    field :currency, :string
    belongs_to(:user, User)

    timestamps()
  end


  @doc false
  def changeset(profile, attrs \\ %{}) do
    profile
    |> cast(attrs, [:name, :type, :currency, :user_id])
    |> validate_required([:name, :type, :currency, :user_id])
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


  def create_with_user(user, form_params)  do

    changeset = %__MODULE__{}
    changeset(%{ form_params | user_id: user.id})


    Repo.transaction(fn ->
      case Repo.insert(changeset) do
        {:ok, profile} ->

          # insert record into user profiles
           case UserProfiles.create(%{"profile_id" => profile.id, "user_id" => profile.user_id}) do
            {:ok, userprofiles} ->
              userprofiles

            {:eror, userprofiles} ->
              Repo.rollback(userprofiles)
           end

        {:error, changeset} ->
          Repo.rollback(changeset)
      end
    end)
  end

  def search_query(q) do
    search_query = "%#{q}"

    from x in __MODULE__,
      where: ilike(x.name, ^search_query)
  end

  def create(params, profile_type) when profile_type in ["user", "business"] do
    changeset =
      %__MODULE__{}
      |> change(type: profile_type)
      |> changeset(params)

    Repo.transaction(fn ->
      case Repo.insert(changeset) do
        {:ok, profile} ->
          create_account!(profile)
          profile

        {:error, changeset} ->
          Repo.rollback(changeset)
      end
    end)
  end

  defp create_account!(profile) do
    %Account{}
    |> change(profile_id: profile.id)
    |> Account.changeset()
    |> Repo.insert!()
  end

  def list_profiles do
    Repo.all(__MODULE__)
  end

  def get_profile!(id), do: Repo.get!(__MODULE__, id)

  def update_profile(%__MODULE__{} = profile, params) do
    profile
    |> changeset(params)
    |> Repo.update()
  end

  def delete_profile(%__MODULE__{} = profile) do
    profile
    |> change(deleted_at: DateTime.utc_now() |> DateTime.truncate(:second))
    |> Repo.update!()
  end

  def edit_profile(%__MODULE__{} = profile) do
    __MODULE__.changeset(profile, %{})
  end
end
