defmodule PheonixLive.Repo.Migrations.CreateCustomers do
  use Ecto.Migration

  def change do
    create table(:customers) do
      add :name, :string
      add :fullname, :string
      add :phone_address, :string
      add :info1, :string
      add :info2, :string
      add :info3, :string

      timestamps()
    end
  end
end
