defmodule ExpressDelivery.PostalCode.StoreTest do
  use ExUnit.Case

  alias ExpressDelivery.PostalCode.Store
  doctest ExpressDelivery

  test "get_geolocation" do
    {lat, long} = Store.get_geolocation("92821")
    assert is_float(lat)
    assert is_float(long)
  end
end
