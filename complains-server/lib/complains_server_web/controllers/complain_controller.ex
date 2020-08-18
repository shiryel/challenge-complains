defmodule CSWeb.ComplainController do
  @moduledoc false
  use CSWeb, :controller

  alias CS.Complains

  defp get_pagination_opts(%{"page" => page, "size" => size}) do
    %{page: String.to_integer(page), size: String.to_integer(size)}
  end

  defp get_pagination_opts(_params), do: %{page: 1, size: 50}

  def index(conn, %{"locale" => locale, "company" => company} = params) do
    opts = get_pagination_opts(params)

    case Complains.list_complains_by_locale_and_company(locale, company, opts) do
      {:error, error} ->
        conn
        |> put_status(:bad_request)
        |> json(error)

      result ->
        conn
        |> json(result)
    end
  end

  def index(conn, %{"locale" => locale} = params) do
    opts = get_pagination_opts(params)

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
end
