defmodule ExSwitch.Shelly.SwitchTest do
  use ExUnit.Case, async: true

  alias ExSwitch.Shelly.Switch

  setup do
    bypass = Bypass.open()
    {:ok, bypass: bypass}
  end

  test "turn_on/1 turns on switch", %{bypass: bypass} do
    Bypass.expect_once(bypass, "POST", "/rpc", fn conn ->
      Plug.Conn.resp(conn, 200, ~s<{"id": 1, "result": {"was_on": false}, "src": "device-id"}>)
    end)

    assert :ok = Switch.turn_on(Switch.new(addr(bypass.port)))
  end

  test "turn_on/1 fails for status other than 200", %{bypass: bypass} do
    Bypass.expect_once(bypass, "POST", "/rpc", fn conn ->
      Plug.Conn.resp(
        conn,
        400,
        ~s<{"id": 0, "src": "device-id", "error": {"code": -105, "message": "Argument 'id', value 1 not found!"}}>
      )
    end)

    assert {:error, {:unexpected_status, 400}} =
             Switch.turn_on(Switch.new(addr(bypass.port)))
  end

  test "turn_on/1 fails with device error", %{bypass: bypass} do
    Bypass.expect_once(bypass, "POST", "/rpc", fn conn ->
      Plug.Conn.resp(
        conn,
        200,
        ~s<{"id": 0, "src": "device-id", "error": {"code": -105, "message": "Argument 'id', value 1 not found!"}}>
      )
    end)

    assert {:error, {:device_error, _}} =
             Switch.turn_on(Switch.new(addr(bypass.port)))
  end

  test "turn_on/1 fails if no JSON is returned", %{bypass: bypass} do
    Bypass.expect_once(bypass, "POST", "/rpc", fn conn ->
      Plug.Conn.resp(
        conn,
        200,
        ~s<some plaintext>
      )
    end)

    assert {:error, {:json_error, _}} = Switch.turn_on(Switch.new(addr(bypass.port)))
  end

  test "turn_off/1 turns off switch", %{bypass: bypass} do
    Bypass.expect_once(bypass, "POST", "/rpc", fn conn ->
      Plug.Conn.resp(conn, 200, ~s<{"id": 1, "result": {"was_on": true}, "src": "device-id"}>)
    end)

    assert :ok = Switch.turn_off(Switch.new(addr(bypass.port)))
  end

  test "turn_off/1 fails for status other than 200", %{bypass: bypass} do
    Bypass.expect_once(bypass, "POST", "/rpc", fn conn ->
      Plug.Conn.resp(
        conn,
        400,
        ~s<{"id": 0, "src": "device-id", "error": {"code": -105, "message": "Argument 'id', value 1 not found!"}}>
      )
    end)

    assert {:error, {:unexpected_status, 400}} =
             Switch.turn_off(Switch.new(addr(bypass.port)))
  end

  test "turn_off/1 fails with device error", %{bypass: bypass} do
    Bypass.expect_once(bypass, "POST", "/rpc", fn conn ->
      Plug.Conn.resp(
        conn,
        200,
        ~s<{"id": 0, "src": "device-id", "error": {"code": -105, "message": "Argument 'id', value 1 not found!"}}>
      )
    end)

    assert {:error, {:device_error, _}} =
             Switch.turn_off(Switch.new(addr(bypass.port)))
  end

  test "turn_off/1 fails if no JSON is returned", %{bypass: bypass} do
    Bypass.expect_once(bypass, "POST", "/rpc", fn conn ->
      Plug.Conn.resp(
        conn,
        200,
        ~s<some plaintext>
      )
    end)

    assert {:error, {:json_error, _}} = Switch.turn_off(Switch.new(addr(bypass.port)))
  end

  defp addr(port), do: "localhost:#{port}"
end
