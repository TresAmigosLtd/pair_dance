defmodule PairDance.Infrastructure.TeamEntity do
  use Ecto.Schema
  import Ecto.Changeset

  schema "teams" do
    field :name, :string
    has_many(:members, PairDance.Teams.Member, foreign_key: :team_id)
    has_many(:tasks, PairDance.Teams.Task)

    timestamps()
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
