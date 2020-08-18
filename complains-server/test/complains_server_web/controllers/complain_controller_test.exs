defmodule CSWeb.ComplainControllerTest do
  use CSWeb.ConnCase

  @valid_complain %{
    title: "A complain",
    description: "Plz read",
    company: %{name: "a company"},
    locale: %{country: "Brazil", state: "SP", city: "São José do Rio Preto"}
  }

  @invalid_complain_by_company_miss %{
    title: "A complain",
    description: "Plz read",
    locale: %{country: "Brazil", state: "SP", city: "São José do Rio Preto"}
  }

  @invalid_complain_by_company_name_miss %{
    title: "A complain",
    description: "Plz read",
    company: %{},
    locale: %{country: "Brazil", state: "SP", city: "São José do Rio Preto"}
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

  @invalid_complain_by_locale_country_invalid %{
    title: "A complain",
    description: "Plz read",
    company: %{name: "a company"},
    locale: %{country: "Zabivaka", state: "SP", city: "São José do Rio Preto"}
  }

  @invalid_complain_by_locale_state_invalid %{
    title: "A complain",
    description: "Plz read",
    company: %{name: "a company"},
    locale: %{country: "Brazil", state: "SCP", city: "São José do Rio Preto"}
  }

  @complain_result %{
    "company" => %{"name" => "a company"},
    "description" => "Plz read",
    "locale" => %{"city" => "São José do Rio Preto", "country" => "Brazil", "state" => "SP"},
    "title" => "A complain"
  }

  describe "index" do
    test "(valid) list all complains", %{conn: conn} do
      conn = get(conn, Routes.complain_path(conn, :index))
      assert json_response(conn, 200) == [@complain_result]
    end

    test "(valid) list all complains with pagination", %{conn: conn} do
      conn = get(conn, Routes.complain_path(conn, :index), %{page: 1, size: 50})
      assert json_response(conn, 200) == [@complain_result]
    end

    test "(valid) list all complains with pagination without results", %{conn: conn} do
      conn = get(conn, Routes.complain_path(conn, :index), %{page: 1000, size: 50})
      assert json_response(conn, 200) == []
    end

    test "(valid) list all complains with invalid pagination", %{conn: conn} do
      conn = get(conn, Routes.complain_path(conn, :index), %{page: 1, size: 100})
      assert json_response(conn, 200) == [@complain_result]
    end

    test "(valid) list all complains with negative pagination size", %{conn: conn} do
      conn = get(conn, Routes.complain_path(conn, :index), %{page: 1, size: -50})
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

    test "(invalid locale.country invalid name) returns 400 and the error value", %{conn: conn} do
      conn =
        post(conn, Routes.complain_path(conn, :create), @invalid_complain_by_locale_country_invalid)

      assert json_response(conn, 400) == %{"locale" => %{"country" => ["is invalid"]}}
    end

    test "(invalid locale.state invalid name) returns 400 and the error value", %{conn: conn} do
      conn =
        post(conn, Routes.complain_path(conn, :create), @invalid_complain_by_locale_state_invalid)

      assert json_response(conn, 400) == %{"locale" => %{"state" => ["is invalid"]}}
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
