defmodule CS.Complains do
  @moduledoc """
  A complain is a document defined as:

  ```
  %{
    complain: %{
      title,
      description,
    },
    company: %{
      name,
      locale: %{
        country,
        state,
        city
      }
    }
  }
  ```

  It uses the Ecto changeset to validate the fields

  WARNING: This module implement a custom `Enumerable` for `Ecto.Changeset`, striping the values of `:changes`

  \0/
  """

  @typedoc """
  Because we validate the struct with ecto, we can receive back the MongoDB result or a list of Ecto.ChangeError
  """
  @type transform_result ::
          {:ok, BSON.document()} | {:error, %{optional(atom) => [binary | map]} | Mongo.Error.t()}

  @typedoc """
  Because we validate the struct with ecto, we can receive back the MongoDB result as a list of maps or a list of Ecto.ChangeError
  """
  @type find_result ::
          [%{}] | {:error, %{optional(atom) => [binary | map]} | Mongo.Error.t()}

  alias __MODULE__.{Company, Complain, Locale}

  ###################
  # IMPLEMENTATIONS #
  ###################

  # Get only the `:changes` from the changeset :3
  defimpl Enumerable, for: Ecto.Changeset do
    def count(map) do
      {:ok, map_size(map.changes)}
    end

    def member?(map, {key, value}) do
      {:ok, match?(%{^key => ^value}, map.changes)}
    end

    def member?(_map, _other) do
      {:ok, false}
    end

    def slice(map) do
      size = map_size(map.changes)
      {:ok, size, &Enumerable.List.slice(:maps.to_list(map.changes), &1, &2, size)}
    end

    def reduce(map, acc, fun) do
      Enumerable.List.reduce(:maps.to_list(map.changes), acc, fun)
    end
  end

  #########
  # UTILS #
  #########

  #A helper that transforms changeset errors into a map of messages.
  #    assert {:error, changeset} = Accounts.create_user(%{password: "short"})
  #    assert "password is too short" in errors_on(changeset).password
  #    assert %{password: ["password is too short"]} = errors_on(changeset)
  defp errors_on(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, opts} ->
      Regex.replace(~r"%{(\w+)}", message, fn _, key ->
        opts |> Keyword.get(String.to_existing_atom(key), key) |> to_string()
      end)
    end)
  end

  # Remove the "_id" from the mongo results
  defp transform_remove_id(mongo_result) do
    case mongo_result do
      {:ok, result} ->
        {:ok, Map.delete(result, "_id")}
      any ->
        any
    end
  end

  #########
  # LISTS #
  #########

  @doc """
  List all complains

  ## Examples

    iex> list_complains()
    [...]
    iex> list_complains(1, 50)
    [...]
  """
  @spec list_complains(integer(), integer()) :: find_result()
  def list_complains(page \\ 1, size \\ 50) do
    Mongo.find(:mongo, "complains", %{}, skip: (page - 1) * size, limit: size)
    |> Enum.to_list()
    |> Enum.map(&Map.delete(&1, "_id"))
  end

  @doc """
  List all complains filtered by a locale

  ## Examples

    iex> list_complains_by_locale(%{country: "brazil", state: "SP", city: "São José do Rio Preto"})
    [...]
  """
  @spec list_complains_by_locale(%{}, integer(), integer()) :: find_result()
  def list_complains_by_locale(attrs, page \\ 1, size \\ 50) do
    changeset = Locale.search_changeset(%Locale{}, attrs)

    if changeset.valid? do
      Mongo.find(:mongo, "complains", %{locale: changeset.changes},
        skip: (page - 1) * size,
        limit: size
      )
      |> Enum.to_list()
      |> Enum.map(&Map.delete(&1, "_id"))
    else
      {:error, errors_on(changeset)}
    end
  end

  @doc """
  List all complains filtered by a locale and the company info

  ## Examples

    iex> list_complains_by_locale(%{country: "brazil", state: "SP", city: "São José do Rio Preto"}, %{name: "Lapfox"})
    [...]
  """
  @spec list_complains_by_locale_and_company(%{}, %{}, integer(), integer()) :: find_result()
  def list_complains_by_locale_and_company(locale_attrs, company_attrs, page \\ 1, size \\ 50) do
    locale_changeset = Locale.search_changeset(%Locale{}, locale_attrs)
    company_changeset = Company.search_changeset(%Company{}, company_attrs)

    if locale_changeset.valid? and company_changeset.valid? do
      Mongo.find(
        :mongo,
        "complains",
        %{locale: locale_changeset.changes, company: company_changeset.changes},
        skip: (page - 1) * size,
        limit: size
      )
      |> Enum.to_list()
      |> Enum.map(&Map.delete(&1, "_id"))
    else
      errors = Map.merge(errors_on(locale_changeset), errors_on(company_changeset))
      {:error, errors}
    end
  end

  ##########
  # CREATE #
  ##########

  @doc """
  Create a new complain

  ## Examples
    
    iex> create_complain(%{title: "A complain", description: "Plz read", company: %{name: "a company"}, locale: %{country: "brazil", state: "SP", city: "São José do Rio Preto"}})
  """
  @spec create_complain(%{}) :: transform_result()
  def create_complain(attrs) do
    changeset = Complain.changeset(%Complain{}, attrs)

    if changeset.valid? do
      Mongo.find_one_and_replace(:mongo, "complains", %{}, changeset.changes,
        return_document: :after,
        upsert: true
      )
      |> transform_remove_id()
    else
      {:error, errors_on(changeset)}
    end
  end

  ##########
  # UPDATE #
  ##########

  @doc """
  Update a complain

  ## Examples
    
      iex> update_complain(%{title: "A complain", description: "Plz read", company: %{name: "a company"}, locale: %{country: "brazil", state: "SP", city: "São José do Rio Preto"}}, \
      %{title: "A complain", description: "Plz read, serious", company: %{name: "a company"}, locale: %{country: "brazil", state: "SP", city: "São José do Rio Preto"}})
      [...]
  """
  @spec update_complain(%{}, %{}) :: transform_result()
  def update_complain(old_attrs, new_attrs) do
    old_changeset = Complain.changeset(%Complain{}, old_attrs)
    new_changeset = Complain.changeset(%Complain{}, new_attrs)

    if old_changeset.valid? and new_changeset.valid? do
      Mongo.find_one_and_update(:mongo, "complains", old_changeset.changes, new_changeset.changes)
      |> transform_remove_id()
    else
      errors = Map.merge(errors_on(old_changeset), errors_on(new_changeset))
      {:error, errors}
    end
  end

  ##########
  # DELETE #
  ##########

  @doc """
  Create a new complain

  ## Examples
    
    iex> delete_complain(%{title: "A complain", description: "Plz read", company: %{name: "a company"}, locale: %{country: "brazil", state: "SP", city: "São José do Rio Preto"}})
  """
  @spec delete_complain(%{}) :: transform_result()
  def delete_complain(attrs) do
    changeset = Complain.changeset(%Complain{}, attrs)

    if changeset.valid? do
      Mongo.find_one_and_delete(:mongo, "complains", changeset.changes)
      |> transform_remove_id()
    else
      {:error, errors_on(changeset)}
    end
  end
end
