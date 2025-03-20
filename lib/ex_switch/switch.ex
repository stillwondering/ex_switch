defmodule ExSwitch.Switch do
  @type switch :: term()

  @callback turn_on(switch()) :: {:ok, switch()} | {:error, term()}

  @callback turn_off(switch()) :: {:ok, switch()} | {:error, term()}
end
