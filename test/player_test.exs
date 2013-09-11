Code.require_file "test_helper.exs", __DIR__

defmodule PlayerTest do
  use ExUnit.Case, async: true 

  import ExUnit.CaptureIO

  test "the truth" do
    assert(true)
  end

  test "can test application code" do
    assert(Player.truth())
  end

  test "can receive game state" do
    assert capture_io(fn -> Player.new_game_state([{:inventory, 4}, {:saldo, 20}, {:delivered, 2}, {:shipped, 8}, {:saldo_diff, 20}]) end) ==  "New inventory is 4 bottles\nNew saldo is 20 dollars\nLast delivery was 2 bottles\nLast shipment was 8 bottles\nThis added 20 dollars to your saldo\n"
  end

  test "can read correctly formated order" do
    assert(Player.parse_order("2") == 2)
    assert(Player.parse_order("52") == 52)
    assert(Player.parse_order("20000") == 20000)
  end

  test "can handle invalid numbers" do
    assert(Player.parse_order("2gugg") == 2)
    assert(Player.parse_order("2 2") == 2)
    assert(Player.parse_order("gugg") == :error)
    assert(Player.parse_order("-1") == :negative_number)
  end

  test "can format inventory messsage" do
    {label, message} = Player.format_msg({:inventory, 4})
    assert(label == :inventory)
    assert(message == "New inventory is 4 bottles")
    {label, message} = Player.format_msg({:inventory, 1})
    assert(label == :inventory)
    assert(message == "New inventory is 1 bottle")
    {label, message} = Player.format_msg({:inventory, -1})
    assert(label == :inventory)
    assert(message == "New inventory is -1 bottles")
  end

  test "can format saldo message" do
    {label, message} = Player.format_msg({:saldo, 4})
    assert(label == :saldo)
    assert(message == "New saldo is 4 dollars")
    {label, message} = Player.format_msg({:saldo, 1})
    assert(label == :saldo)
    assert(message == "New saldo is 1 dollar")
    {label, message} = Player.format_msg({:saldo, -1})
    assert(label == :saldo)
    assert(message == "New saldo is -1 dollars")
  end

  test "can format delivered message" do
    {label, message} = Player.format_msg({:delivered, 4})
    assert(label == :delivered)
    assert(message == "Last delivery was 4 bottles")
    {label, message} = Player.format_msg({:delivered, 1})
    assert(label == :delivered)
    assert(message == "Last delivery was 1 bottle")
  end

  test "can format shipped message" do
    {label, message} = Player.format_msg({:shipped, 4})
    assert(label == :shipped)
    assert(message == "Last shipment was 4 bottles")
    {label, message} = Player.format_msg({:shipped, 1})
    assert(label == :shipped)
    assert(message == "Last shipment was 1 bottle")
  end

  test "can format saldo differece message" do
    {label, message} = Player.format_msg({:saldo_diff, 4})
    assert(label == :saldo_diff)
    assert(message == "This added 4 dollars to your saldo")
    {label, message} = Player.format_msg({:saldo_diff, 1})
    assert(label == :saldo_diff)
    assert(message == "This added 1 dollar to your saldo")
    {label, message} = Player.format_msg({:saldo_diff, -1})
    assert(label == :saldo_diff)
    assert(message == "This lowered your saldo by 1 dollar")
    {label, message} = Player.format_msg({:saldo_diff, -2})
    assert(label == :saldo_diff)
    assert(message == "This lowered your saldo by 2 dollars")
  end

  test "can display new incoming order" do
    assert capture_io(fn -> Player.new_order(0) end) == "Incoming order of 0 bottles\n"
    assert capture_io(fn -> Player.new_order(1) end) == "Incoming order of 1 bottle\n"
    assert capture_io(fn -> Player.new_order(2) end) == "Incoming order of 2 bottles\n"
 end
end
