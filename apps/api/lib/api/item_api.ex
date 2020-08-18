defmodule ItemApi do
  use GenServer
  #######
  # API #
  #######
  def start_link do
    GenServer.start_link(__MODULE__, [], name: {:global, __MODULE__})
  end

  def get_item_by_id(id) do
    GenServer.call({:global, __MODULE__}, {:get_item_by_id, id: id})
  end

  #############
  # Callbacks #
  #############
  def init(_) do
    IO.inspect("abc")
    {:ok, %{}}
  end

  def handle_call({:create_item, item: item, params: params}, _from, state) do
    # cancast here
    result = ItemService.create_item(item, params)

    _result =
      case result do
        {:ok, item} ->
          Cachex.put(:item_cache, item.id, item)

        _error ->
          :error
      end

    {:reply, result, state}
  end

  def handle_call({:update_item, item: item, params: params}, _from, state) do
    # cancast here ------- transaction here --------
    result = ItemService.update_item(item, params)

    _result =
      case result do
        {:ok, item} ->
          Cachex.put(:item_cache, item.id, item)

        _error ->
          :error
      end

    {:reply, result, state}
  end

  def handle_call({:get_item_by_id, id: id}, _from, state) do
    result = Cachex.get(:item_cache, id)

    item =
      case result do
        {:ok, nil} ->
          item = ItemService.get_item_by_id(id)

          _result =
            case item do
              %Item{} ->
                Cachex.put(:item_cache, item.id, item)

              _ ->
                nil
            end

          item

        {:ok, %Item{} = item} ->
          item

        {:error, :nodedown} ->
          item = ItemService.get_item_by_id(id)

          _result =
            case item do
              %Item{} ->
                Cachex.put(:item_cache, item.id, item)

              _ ->
                Cachex.put(:item_cache, id, :delete)
                nil
            end

          item

        _error ->
          nil
      end

    {:reply, item, state}
  end

  def handle_call(:get_all_item, _from, state) do
    items = ItemService.get_all_item()

    {:reply, items, state}
  end

  def handle_call({:delete_item, item: item}, _from, state) do
    # cancast here ------- transaction here --------
    result = ItemService.delete_item(item)

    _result =
      case result do
        {:ok, item} ->
          Cachex.del(:item_cache, item.id)

        _error ->
          :error
      end

    {:reply, result, state}
  end
end
