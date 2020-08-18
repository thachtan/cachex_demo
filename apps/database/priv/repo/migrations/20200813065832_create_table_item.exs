defmodule Database.Repo.Migrations.CreateTableItem do
  use Ecto.Migration

  def change do
    create table(:item) do
      add :name, :string
      add :quantity, :integer
    end
  end
end
