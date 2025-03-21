defmodule ExSwitch.Shelly.Switch do
  @moduledoc """
  Struct representing a Shelly switch.
  """
  alias __MODULE__

  @type t :: %Switch{addr: binary()}

  @enforce_keys [:addr]
  defstruct [:addr]

  @doc """
  Creates a new switch with the given `address`.

  `address` should be a valid IP address or "localhost".

  ## Examples

      iex> ExSwitch.Shelly.Switch.new("10.0.0.1")
      %ExSwitch.Shelly.Switch{addr: "10.0.0.1"}
  """
  @spec new(binary()) :: t()
  def new(address), do: %Switch{addr: address}

  @doc """
  Turns on the given `switch`.

  Currently, this function can only interact with the device via HTTP.
  """
  @spec turn_on(t()) :: :ok | {:error, term()}
  def turn_on(%Switch{} = switch) do
    ExSwitch.Shelly.HTTP.turn_on(switch.addr)
  end

  @doc """
  Turns off the given `switch`.

  Currently, this function can only interact with the device via HTTP.
  """
  @spec turn_off(t()) :: :ok | {:error, term()}
  def turn_off(%Switch{} = switch) do
    ExSwitch.Shelly.HTTP.turn_off(switch.addr)
  end
end
