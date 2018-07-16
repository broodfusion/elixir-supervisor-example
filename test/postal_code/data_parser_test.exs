defmodule ExpressDelivery.PostalCode.DataParserTest do
  use ExUnit.Case

  alias ExpressDelivery.PostalCode.DataParser
  doctest ExpressDelivery

  test "parse_data" do
    geolocation_data = DataParser.parse_data()
    {lat, long} = Map.get(geolocation_data, "92821")

    assert is_float(lat)
    assert is_float(long)
  end
end
