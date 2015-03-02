defmodule Kalecto.DateTimeUTC do
  require Kalends.DateTime
  import Ecto.DateTime.Util

  @moduledoc """
  Kalends DateTime for Ecto for representing only UTC datetimes
  """

  @behaviour Ecto.Type

  @doc """
  The Ecto primitive type.
  """
  def type, do: :datetime

  @doc """
  Datetimes are blank when given as strings and the string is blank.
  """
  defdelegate blank?(value), to: Ecto.Type

  @doc """
  Casts to date.
  """
  def cast(<<year::32, ?-, month::16, ?-, day::16, sep,
             hour::16, ?:, min::16, ?:, sec::16, rest::binary>>) when sep in [?\s, ?T] do
    if valid_rest?(rest) do
      from_parts(to_li(year), to_i(month), to_i(day),
                 to_i(hour), to_i(min), to_i(sec))
    else
      :error
    end
  end
  def cast(%Kalends.DateTime{timezone: "Etc/UTC"} = dt),
    do: {:ok, dt}
  def cast(_),
    do: :error

  defp from_parts(year, month, day, hour, min, sec) do
    load({{year, month, day},{hour, min, sec}})
  end
  defp from_parts(_, _, _, _, _, _), do: :error

  @doc """
  Converts to erlang style tuples
  """
  def dump(%Kalends.DateTime{timezone: "Etc/UTC"} = dt) do
    {:ok, Kalends.DateTime.to_erl(dt)}
  end
  def dump(_), do: :error

  @doc """
  Converts erlang style tuples to `Kalends.DateTime`
  """
  def load({{year, month, day}, {hour, min, sec}}) do
    Kalends.DateTime.from_erl({{year, month, day}, {hour, min, sec}}, "Etc/UTC")
  end
end
