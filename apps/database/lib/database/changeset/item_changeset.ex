defmodule Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "item" do
    field :name, :string
    field :quantity, :integer
  end

  def changeset(%Item{} = item, %{} = params \\ %{}) do
    item
    |> cast(params, [:name, :quantity])
  end

end
