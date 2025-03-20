defmodule ExSwitch.Shelly.HTTP do
  def turn_on(addr) do
    body =
      %{"id" => 1, "method" => "Switch.Set", "params" => %{"id" => 0, "on" => true}}
      |> JSON.encode!()

    req = Finch.build(:post, rpc_endpoint(addr), [], body)

    with {:ok, resp} <- Finch.request(req, ExSwitch.Finch),
         {:ok, _status} <- validate_http_status(resp),
         {:ok, decoded} <- parse_body(resp) do
      validate_no_error(decoded)
    end
  end

  def turn_off(addr) do
    body =
      %{"id" => 1, "method" => "Switch.Set", "params" => %{"id" => 0, "on" => false}}
      |> JSON.encode!()

    req = Finch.build(:post, rpc_endpoint(addr), [], body)

    with {:ok, resp} <- Finch.request(req, ExSwitch.Finch),
         {:ok, _status} <- validate_http_status(resp),
         {:ok, decoded} <- parse_body(resp) do
      validate_no_error(decoded)
    end
  end

  defp validate_http_status(%Finch.Response{} = resp) do
    case resp.status do
      200 = status -> {:ok, status}
      status -> {:error, {:unexpected_status, status}}
    end
  end

  defp parse_body(%Finch.Response{} = resp) do
    case JSON.decode(resp.body) do
      {:ok, _decoded} = result -> result
      {:error, reason} -> {:error, {:json_error, reason}}
    end
  end

  defp validate_no_error(%{} = decoded) do
    case decoded do
      %{"error" => error} -> {:error, {:device_error, error}}
      _ -> :ok
    end
  end

  defp rpc_endpoint(addr), do: "http://#{addr}/rpc"
end
