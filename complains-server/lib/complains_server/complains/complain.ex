defmodule CS.Complains.Complain do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  @required ~w[title description]a

  @primary_key {:id, :binary_id, autogenerate: true}  # the id maps to uuid
  schema "complains" do
    field :title, :string
    field :description, :string
    embeds_one :company, CS.Complains.Company
    embeds_one :locale, CS.Complains.Locale
  end

  @spec changeset(%__MODULE__{}, any) :: Ecto.Changeset.t()
  def changeset(complain, attrs) do
    complain
    |> cast(attrs, @required)
    |> cast_embed(:company, required: true)
    |> cast_embed(:locale, required: true)
    |> validate_required(@required)
  end

  @spec search_changeset(%__MODULE__{}, any) :: Ecto.Changeset.t()
  def search_changeset(company, attrs) do
    company
    |> cast(attrs, @required)
    |> cast_embed(:company, required: false)
    |> cast_embed(:locale, required: false)
  end
end
