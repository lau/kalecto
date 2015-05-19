defmodule Calecto.Model do
  @moduledoc """
  Provides a `use` macro for adding Calendar support to Ecto timestamps.

  It also takes an argument to define whether microseconds should be
  used for Ecto timestamps. It is recommended to set this to true
  unless a MySQL database older than 5.0 is used.

  The macro can either be added in the Ecto models where schema definitions
  exist.

  Example:

  ```
  defmodule Weather do
    use Ecto.Model
    use Calecto.Model, usec: true

    schema "weather" do
      field :city, :string
      timestamps
    end
  end
  ```

  ## Usage with Phoenix

  In Phoenix the file `web/web.ex` contains a macro that is by default used in
  all models. This means that you can simply add the `use Calecto.Model` line
  in that file once, and it will be used in all models.

  Find the method defintion `model` and add the `use Calecto.Model` line under
  `use Ecto.Model`:

  ```elixir
  # web/web.ex
  # ...

  def model do
    quote do
      use Ecto.Model
      use Calecto.Model, usec: true
    end
  end
  ```

  """
  @default_timestamps_opts [type: Calecto.DateTimeUTC]
  defmacro __using__(opts) do
    quote do
      @timestamps_opts unquote(Dict.merge(opts, @default_timestamps_opts))
    end
  end
end
