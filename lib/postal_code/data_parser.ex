defmodule ExpressDelivery.PostalCode.DataParser do
  @postal_code_filepath "data/2017_Gaz_zcta_national.txt"

  def parse_data do
    [_header | data_rows] =
      File.read!(@postal_code_filepath)
      |> String.split("\n")

    data_rows
    |> Stream.map(&String.split(&1, "\t"))
    |> Stream.filter(&data_row?(&1))
    |> Stream.map(&parse_data_columns(&1))
    |> Stream.map(&format_row(&1))
    |> Enum.into(%{})
  end

  defp data_row?(row) do
    case row do
      [_postal_code, _, _, _, _, _lat, _long] -> true
      _ -> false
    end
  end

  defp parse_data_columns(row) do
    [postal_code, _, _, _, _, lat, long] = row
    [postal_code, lat, long]
  end

  defp parse_number(str) do
    str |> String.replace(" ", "") |> String.to_float()
  end

  # format three element list into a two element tuple
  # [postal_code, lat, long] # => {postal_code, {lat, long}}
  defp format_row([postal_code, lat, long]) do
    {postal_code, {parse_number(lat), parse_number(long)}}
  end
end
