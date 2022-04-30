defmodule PheonixLive.Repo.Migrations.AddForGroupFieldCustomerReport do
  use Ecto.Migration

  def change do
    alter table(:customers_report) do
      add :group_ref, :string
    end
    create table(:groups_detail) do
      add :user_id, :integer
      add :group_name, :string

      timestamps()
    end
  end
end
