defmodule PairDance.Infrastructure.EctoTeamRepository do

  alias PairDance.Domain.TeamRepository

  alias PairDance.Infrastructure.TeamEntity
  alias PairDance.Infrastructure.TeamMemberEntity

  import Ecto.Query, warn: false
  alias PairDance.Repo

  import PairDance.Infrastructure.EntityConverters

  @behaviour TeamRepository

  @impl TeamRepository
  def create(name) do
    {:ok, entity } = %TeamEntity{}
      |> TeamEntity.changeset(%{ name: name })
      |> Repo.insert()
    {:ok, find(entity.id)}
  end

  @impl TeamRepository
  def find(id) do
    entity = Repo.one from t in TeamEntity, where: t.id == ^id, preload: [:members, [members: :user]]
    if entity == nil do
      nil
    else
      to_team(entity)
    end
  end

  @impl TeamRepository
  def find_all() do
    Repo.all(from t in TeamEntity, preload: [:members]) |> Enum.map(&to_team/1)
  end

  @impl TeamRepository
  def update(team_id, patch) do
    {:ok, _entity} = TeamEntity.changeset(%TeamEntity{ id: team_id }, patch) |> Repo.update()

    {:ok, find(team_id)}
  end

  @impl TeamRepository
  def delete(id) do
    {:ok, _entity} = Repo.delete(%TeamEntity{ id: id })
    {:ok}
  end

  @impl TeamRepository
  def add_member(team, member) do
    {:ok, _} = %TeamMemberEntity{}
      |> TeamMemberEntity.changeset(%{ user_id: member.user.id, team_id: team.id })
      |> Repo.insert()
    {:ok, find(team.id)}
  end
end
