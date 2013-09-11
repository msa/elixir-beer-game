defmodule BeerGameServer do

  @external_orders [4,4,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8,8]
  @valid_roles [:producer, :wholesaler, :retailer, :distributor]

  def truth do
    true
  end

  def beer_game_server(state) do
    receive do
      {:register,reg_request} ->
        [global_state, players, orders] = state 
        {code, players2} = register(reg_request, players)
        respond_to_client(code, reg_request)
        start_game(players2)
        beer_game_server([global_state, players2, orders])
      {:do_end} -> 
    end
  end

  def start_game({:players, players}) when length(players) == 4 do
    Enum.map(players, fn {_role, pid} -> pid <- :game_started end)
  end
  
  def start_game({:players, _players}) do
  end

  def respond_to_client(code, {role, pid}) do
    pid <- {:register, code, role}
  end

  def place_order(order, {:players, players}, orders) when length(players) == 4 do
    [order|orders]   
  end

  def place_order(_order, _players, _orders) do
    :rejected_waiting_for_more_players
  end

  def register(player, players) do
    {requested_role, _pid} = player
    if is_valid_role(requested_role) do
      do_register(player, players)
    else
      {:bad_role, players}
    end
  end

  def do_register(player, {:players, []}) do
      {:ok, {:players, [player]}}
  end

  def do_register(player, {:players, players}) do
    {requested_role, _pid} = player
    previous = Enum.find(players, fn {role, _pid} -> role == requested_role end)
    if previous == nil do
      {:ok, {:players, [player|players]}}
    else
      {:already_registered, {:players, players}}
    end

  end

  def is_valid_role(role) do
    role in @valid_roles
  end
end
