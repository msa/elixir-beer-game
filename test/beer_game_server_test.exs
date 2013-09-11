Code.require_file "test_helper.exs", __DIR__
import :timer, only: [ sleep: 1 ]
import ExUnit.CaptureIO

defmodule BeerGameServerTest do
  use ExUnit.Case, async: true

  test "the truth" do
    assert(true)
  end

  test "can test application code" do
    assert(BeerGameServer.truth())
  end

  test "can start server and shutdown server" do
    pid = spawn_link(BeerGameServer, :beer_game_server, [[{:global_state,[]},{:players,[]},{:orders,[]}]])
    pid <- {:do_end}
  end

  test "can start server and accept registrations" do
    pid = spawn_link(BeerGameServer, :beer_game_server, [[{:global_state,[]},{:players,[]},{:orders,[]}]])
    pid <- {:register, {:producer, self}} 
    assert_receive {:register, :ok, :producer}
    pid <- {:do_end}
  end

  test "can reject second of two identical registrations" do
    pid = spawn_link(BeerGameServer, :beer_game_server, [[{:global_state,[]},{:players,[]},{:orders,[]}]])
    pid <- {:register, {:producer, self}}
    assert_receive {:register, :ok, :producer}
    pid <- {:register, {:producer, self}}
    assert_receive {:register, :already_registered, :producer}
    pid <- {:do_end}
  end

  test "can start game when all roles registered" do
    pid = spawn_link(BeerGameServer, :beer_game_server, [[{:global_state,[]},{:players,[]},{:orders,[]}]])
    pid <- {:register, {:producer, self}}
    assert_receive {:register, :ok, :producer}
    pid <- {:register, {:wholesaler, create_fake_player()}}
    pid <- {:register, {:distributor, create_fake_player()}}
    pid <- {:register, {:retailer, create_fake_player()}}
    assert_receive :game_started
    pid <- {:do_end}
  end

  def create_fake_player do
    spawn(BeerGameServerTest, :fake_player, [])
  end

  def fake_player do
  end

end
