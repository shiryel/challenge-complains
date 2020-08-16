defmodule CS.Complains.Locale do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  @required ~w[country]a
  @optional ~w[state city]a

  @primary_key false
  schema "locales" do
    field :country, :string
    field :state, :string, default: ""
    field :city, :string, default: ""
  end

  @spec changeset(%__MODULE__{}, any) :: Ecto.Changeset.t()
  def changeset(locale, attrs) do
    locale
    |> cast(attrs, @required ++ @optional)
    |> validate_required(@required)
  end

  @spec search_changeset(%__MODULE__{}, any) :: Ecto.Changeset.t()
  def search_changeset(company, attrs) do
    company
    |> cast(attrs, @required ++ @optional)
  end
end
