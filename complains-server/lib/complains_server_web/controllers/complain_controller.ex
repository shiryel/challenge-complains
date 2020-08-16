defmodule CSWeb.ComplainController do
  @moduledoc false
  use CSWeb, :controller

  alias CS.Complains

  # TODO: put pagenate if exists

  def index(conn, %{"locale" => locale, "company" => company}) do
    case Complains.list_complains_by_locale_and_company(locale, company) do
      {:error, error} ->
        conn
        |> put_status(:bad_request)
        |> json(error)

      result ->
        conn
        |> json(result)
    end
  end

  def index(conn, %{"locale" => locale}) do
    case Complains.list_complains_by_locale(locale) do
      {:error, error} ->
        conn
        |> put_status(:bad_request)
        |> json(error)

      result ->
        conn
        |> json(result)
    end
  end
  
  def index(conn, _params) do
    result = Complains.list_complains()
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
