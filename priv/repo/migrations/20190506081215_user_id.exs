defmodule Remit.Repo.Migrations.UserId do
  use Ecto.Migration

  def change do
    alter table(:profiles) do
      add :user_id, references(:users)
    end


  end
end
