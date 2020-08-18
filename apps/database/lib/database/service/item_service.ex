defmodule ItemService do
  alias Database.Repo


  def create_item(%Item{} = item, %{} = params \\ %{}) do
    item
    |> Item.changeset(params)
    |> Repo.insert()
  end

  def update_item(%Item{} = item, %{} = params \\ %{}) do
    item
    |> Item.changeset( params)
    |> Repo.update()
  end

  def get_item_by_id(id) when is_integer(id) do
    Repo.get(Item, id)
  end

  def get_item_by_id(_)  do
    nil
  end

  def get_all_item() do
    Repo.all(Item)
  end

  def delete_item(%Item{} = item) do
    Repo.delete(item)
  end
end
