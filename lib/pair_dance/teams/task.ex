defmodule PairDance.Teams.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :name, :string
    belongs_to(:team, PairDance.Teams.Team)

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:name, :team_id])
    |> foreign_key_constraint(:team_id)
    |> validate_required([:name, :team_id])
  end
end