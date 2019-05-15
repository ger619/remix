defmodule Remit.SMSLogAdapater do
  @behaviour Remit.SMS

  require Logger

  def deliver(msisdn, message, config) do
    Logger.info(
      "Delivering message: #{message} to msisdn: #{msisdn} with config: #{inspect(config)}"
    )

    {:ok, :sent}
  end
end
