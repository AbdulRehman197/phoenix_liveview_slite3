defmodule PheonixLive.Repo.Migrations.AddCustomerReportTable do
  use Ecto.Migration

  def change do
    create table(:customers_report) do
      add :customer_id, :integer
      add :customer_detail, :string
      add :report1, :string
      add :report2, :string
      add :report3, :string
      add :report4, :string
      add :report5, :string

      timestamps()
    end
  end
end
