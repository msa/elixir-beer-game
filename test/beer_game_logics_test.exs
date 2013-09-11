Code.require_file "test_helper.exs", __DIR__

defmodule BeerGameLogicsTest do
  use ExUnit.Case, async: true 

  test "the truth" do
    assert(true)
  end

  test "can test application code" do
    assert(BeerGameServer.truth())
  end

  test "can register producer" do
    pid = create_fake_player()
    assert(BeerGameServer.register({:producer,pid}, {:players,[]}) == {:ok,{:players, [{:producer, pid}]}})
  end

  test "can not register two players of the same kind" do
    pid = create_fake_player()
    assert(BeerGameServer.register({:producer,pid}, {:players, [{:producer, pid}]}) == {:already_registered, {:players, [{:producer, pid}]}})
  end

  test "can not register a player of an unknown kind" do
    pid = create_fake_player()
    assert(BeerGameServer.register({:foo, pid}, {:players, []}) == {:bad_role, {:players, []}})
  end

  test "accepts orders and adds them to orders collection" do
    pid = create_fake_player()
    assert(BeerGameServer.place_order({:producer, 8}, {:players, [{:producer, pid}, {:wholesaler, pid}, {:distributor, pid}, {:retailer, pid}]}, []) == [{:producer, 8}])
    assert(BeerGameServer.place_order({:producer, 8}, {:players, [{:producer, pid}, {:wholesaler, pid}, {:distributor, pid}, {:retailer, pid}]}, [{:wholesaler, 4}]) == [{:producer, 8}, {:wholesaler, 4}])
  end

  test "rejects orders that occur before players have registered" do
    pid = create_fake_player()
    assert(BeerGameServer.place_order({:producer, 8}, {:players, [{:producer, pid}]}, []) == :rejected_waiting_for_more_players)
  end

  def create_fake_player do
    spawn(BeerGameServerTest, :fake_player, [])
  end

  def fake_player do
  end

end
