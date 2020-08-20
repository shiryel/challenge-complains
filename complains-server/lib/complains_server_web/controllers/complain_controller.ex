defmodule CSWeb.ComplainController do
  @moduledoc false
  use CSWeb, :controller

  alias CS.Complains

  def index(conn, %{"locale_country" => _, "company_name" => company_name} = params) do
    opts = get_pagination_opts(params)
    locale = get_locale_params(params)

    case Complains.list_complains_by_locale_and_company(locale, %{name: company_name}, opts) do
      {:error, error} ->
        conn
        |> put_status(:bad_request)
        |> json(error)

      result ->
        conn
        |> json(result)
    end
  end

  def index(conn, %{"locale_country" => _} = params) do
    opts = get_pagination_opts(params)
    locale = get_locale_params(params)
    IO.inspect locale

    case Complains.list_complains_by_locale(locale, opts) do
      {:error, error} ->
        conn
        |> put_status(:bad_request)
        |> json(error)

      result ->
        conn
        |> json(result)
    end
  end

  def index(conn, params) do
    opts = get_pagination_opts(params)
    result = Complains.list_complains(opts)
    json(conn, result)
  end

  def create(conn, params) do
    case Complains.create_complain(params) do
      {:error, error} ->
        conn
        |> put_status(:bad_request)
        |> json(error)

      {:ok, result} ->
        conn
        |> json(result)
    end
  end

  #########
  # UTILS #
  #########

  defp get_pagination_opts(%{"page" => page, "size" => size}) do
    %{page: String.to_integer(page), size: String.to_integer(size)}
  end

  defp get_pagination_opts(_params), do: %{page: 1, size: 50}

  defp get_locale_params(locale) do
    new_locale =
      case Map.fetch(locale, "locale_country") do
        {:ok, country} ->
          %{country: country}

        _ ->
          %{}
      end

    new_locale =
      case Map.fetch(locale, "locale_state") do
        {:ok, state} ->
          Map.merge(new_locale, %{state: state})

        _ ->
          new_locale
      end

    case Map.fetch(locale, "locale_city") do
      {:ok, city} ->
        Map.merge(new_locale, %{city: city})

      _ ->
        new_locale
    end
  end
end
