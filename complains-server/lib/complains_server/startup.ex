defmodule CS.Startup do
  @moduledoc """
  Module to exec commands after the `CS.Application` finish starting all the applications
  """
  require Logger

  @doc """
  Ensure that all the indexes of mongodb are up
  """
  @spec ensure_indexes() :: :ok
  def ensure_indexes do
    Logger.info("Ensuring indexes...")

    Mongo.command(:mongo, %{
      createIndexes: "complains",
      indexes: [
        %{key: %{"company.name": 1}, name: "company_name_idx", unique: false},
        %{key: %{locale: 1}, name: "locale_idx", unique: true}
      ]
    })
    |> inspect()
    |> Logger.info()
  end
end
