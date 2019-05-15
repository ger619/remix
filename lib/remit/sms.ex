defmodule Remit.SMS do
  @callback deliver(String.t(), String.t(), Keyword.t()) :: {:ok, any()} | {:error, any()}

  def deliver(msisdn, message) do
    config = Application.fetch_env!(:remit, __MODULE__)

    adapter =
      config
      |> Keyword.fetch!(:adapter)

    adapter.deliver(msisdn, message, config)
  end
end
