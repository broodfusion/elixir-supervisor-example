defmodule ExpressDelivery do
  use Application

  def start(_type, _args) do
    ExpressDelivery.Supervisor.start_link()
  end
end
