defmodule PairDance.Infrastructure.TeamEntity do
  use Ecto.Schema
  import Ecto.Changeset

  schema "teams" do
    field :name, :string
    has_many(:members, PairDance.Infrastructure.TeamMemberEntity, foreign_key: :team_id)
    has_many(:tasks, PairDance.Teams.Task, foreign_key: :team_id)

    timestamps()
  end

  @doc false
  def changeset(team, attrs) do
    team
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end