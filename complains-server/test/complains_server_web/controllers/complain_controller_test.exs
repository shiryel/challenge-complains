defmodule CSWeb.ComplainControllerTest do
  use CSWeb.ConnCase

  @valid_complain %{
    title: "A complain",
    description: "Plz read",
    company: %{name: "a company"},
    locale: %{country: "brazil", state: "SP", city: "São José do Rio Preto"}
  }

  @invalid_complain_by_company_miss %{
    title: "A complain",
    description: "Plz read",
    locale: %{country: "brazil", state: "SP", city: "São José do Rio Preto"}
  }

  @invalid_complain_by_company_name_miss %{
    title: "A complain",
    description: "Plz read",
    company: %{},
    locale: %{country: "brazil", state: "SP", city: "São José do Rio Preto"}
  }

  @invalid_complain_by_locale_miss %{
    title: "A complain",
    description: "Plz read",
    company: %{name: "a company"}
  }

  @invalid_complain_by_locale_country_miss %{
    title: "A complain",
    description: "Plz read",
    company: %{name: "a company"},
    locale: %{state: "SP", city: "São José do Rio Preto"}
  }

  @complain_result %{
    "company" => %{"name" => "a company"},
    "description" => "Plz read",
    "locale" => %{"city" => "São José do Rio Preto", "country" => "brazil", "state" => "SP"},
    "title" => "A complain"
  }

  describe "index" do
    test "(valid) list all complains", %{conn: conn} do
      conn = get(conn, Routes.complain_path(conn, :index))
      assert json_response(conn, 200) == [@complain_result]
    end
  end

  describe "create" do
    test "(valid) create a new post returns 200 and the created value", %{conn: conn} do
      conn = post(conn, Routes.complain_path(conn, :create), @valid_complain)

      assert json_response(conn, 200) == @complain_result
    end

    test "(invalid locale) returns 400 and the error value", %{conn: conn} do
      conn = post(conn, Routes.complain_path(conn, :create), @invalid_complain_by_locale_miss)

      assert json_response(conn, 400) == %{"locale" => ["can't be blank"]}
    end

    test "(invalid locale.country) returns 400 and the error value", %{conn: conn} do
      conn =
        post(conn, Routes.complain_path(conn, :create), @invalid_complain_by_locale_country_miss)

      assert json_response(conn, 400) == %{"locale" => %{"country" => ["can't be blank"]}}
    end

    test "(invalid company) returns 400 and the error value", %{conn: conn} do
      conn = post(conn, Routes.complain_path(conn, :create), @invalid_complain_by_company_miss)

      assert json_response(conn, 400) == %{"company" => ["can't be blank"]}
    end

    test "(invalid company.name) returns 400 and the error value", %{conn: conn} do
      conn =
        post(conn, Routes.complain_path(conn, :create), @invalid_complain_by_company_name_miss)

      assert json_response(conn, 400) == %{"company" => %{"name" => ["can't be blank"]}}
    end
  end
end
