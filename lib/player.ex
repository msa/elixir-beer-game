defmodule Player do
  def truth do
    true
  end  

  def new_game_state(game_state) do
    messages = Enum.map game_state, fn n -> format_msg(n) end
    Enum.map messages, fn {_label, message} -> IO.puts(message) end
  end

  def format_msg({:inventory, 1}) do
    {:inventory, "New inventory is 1 bottle"}
  end

  def format_msg({:inventory, count}) do
    {:inventory, "New inventory is #{count} bottles"}
  end

  def format_msg({:saldo, 1}) do
    {:saldo, "New saldo is 1 dollar"}
  end

  def format_msg({:saldo, count}) do
    {:saldo, "New saldo is #{count} dollars"}
  end

  def format_msg({:delivered, 1}) do
    {:delivered, "Last delivery was 1 bottle"}
  end

  def format_msg({:delivered, count}) do
    {:delivered, "Last delivery was #{count} bottles"}
  end

  def format_msg({:shipped, 1}) do
    {:shipped, "Last shipment was 1 bottle"}
  end

  def format_msg({:shipped, count}) do
    {:shipped, "Last shipment was #{count} bottles"}
  end

  def format_msg({:saldo_diff, 1}) do
    {:saldo_diff, "This added 1 dollar to your saldo"}
  end

  def format_msg({:saldo_diff, count}) when (count > 1 or count == 0) do
    {:saldo_diff, "This added #{count} dollars to your saldo"}
  end

  def format_msg({:saldo_diff, count}) when count < -1 do
    {:saldo_diff, "This lowered your saldo by #{abs(count)} dollars"}
  end

  def format_msg({:saldo_diff, -1}) do
    {:saldo_diff, "This lowered your saldo by 1 dollar"}
  end


  def parse_order(:error) do
    :error
  end

  def parse_order({num, _}) when num >= 0 do
    num
  end

  def parse_order({num, _}) when num < 0 do
    :negative_number
  end

  def parse_order(order_str) do
    parse_order(String.to_integer(String.strip(order_str)))
  end

  def new_order(1) do
    IO.puts("Incoming order of 1 bottle")
  end

  def new_order(order) do
    IO.puts("Incoming order of #{order} bottles")
  end
end
