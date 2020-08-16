defmodule CS.Complains.Company do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  @required ~w[name]a
  @optional ~w[description]a

  @primary_key false
  schema "companys" do
    field :name, :string
    field :description, :string, default: ""
  end

  @spec changeset(%__MODULE__{}, any) :: Ecto.Changeset.t()
  def changeset(company, attrs) do
    company
    |> cast(attrs, @required ++ @optional)
    |> validate_required(@required)
  end

  @spec search_changeset(%__MODULE__{}, any) :: Ecto.Changeset.t()
  def search_changeset(company, attrs) do
    company
    |> cast(attrs, @required ++ @optional)
  end
end
