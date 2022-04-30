defmodule PheonixLive.Company.ReportGroup do
  use Ecto.Schema
  import Ecto.Changeset

  schema "groups_detail" do
    field :user_id, :integer
    field :group_name, :string

    timestamps()
  end

  @doc false
  def changeset(group_detail, attrs) do
    group_detail
    |> cast(attrs, [:user_id, :group_name])
    # |> validate_required([:customer_id, :customer_detail, :report1, :report2, :report3, :report4, :report5])
  end
end
