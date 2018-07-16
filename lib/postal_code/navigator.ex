defmodule ExpressDelivery.PostalCode.Navigator do
  use GenServer
  alias ExpressDelivery.PostalCode.{Store, Cache}
  # in km
  @radius 6371
  # @radius 3959 # in miles

  def start_link do
    GenServer.start_link(__MODULE__, [], name: :postal_code_navigator)
  end

  def get_distance(from, to) do
    GenServer.call(:postal_code_navigator, {:get_distance, from, to})
  end

  def handle_call({:get_distance, from, to}, _from, []) do
    distance = do_get_distance(from, to)
    {:reply, distance, []}
  end

  defp do_get_distance(from, to) do
    from = format_postal_code(from)
    to = format_postal_code(to)

    case Cache.get_distance(from, to) do
      nil ->
        {lat1, long1} = get_geolocation(from)
        {lat2, long2} = get_geolocation(to)
        distance = calculate_distance({lat1, long1}, {lat2, long2})
        Cache.set_distance(from, to, distance)
        distance

      distance ->
        distance
    end
  end

  defp get_geolocation(postal_code) do
    Store.get_geolocation(postal_code)
  end

  defp format_postal_code(postal_code) when is_binary(postal_code) do
    postal_code
  end

  defp format_postal_code(postal_code) when is_integer(postal_code) do
    postal_code = Integer.to_string(postal_code)
    format_postal_code(postal_code)
  end

  defp format_postal_code(postal_code) do
    error = "unexpected `postal_code`, received: (#{inspect(postal_code)})"
    raise ArgumentError, error
  end

  defp calculate_distance({lat1, long1}, {lat2, long2}) do
    lat_diff = Math.deg2rad(lat2 - lat1)
    long_diff = Math.deg2rad(long2 - long1)

    lat1 = Math.deg2rad(lat1)
    lat2 = Math.deg2rad(lat2)

    a =
      Math.pow(Math.sin(lat_diff), 2) +
        Math.pow(Math.sin(long_diff), 2) * Math.cos(lat1) * Math.cos(lat2)

    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
    (@radius * c) |> Float.round(2)
  end
end
