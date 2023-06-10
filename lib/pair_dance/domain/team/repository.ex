defmodule PairDance.Domain.Team.Repository do

  alias PairDance.Domain.Team.Assignment
  alias PairDance.Domain.Team
  alias PairDance.Domain.Team.Member

  @type team_id :: integer
  @type slug :: String.t
  @type task_name :: String.t

  @callback create(String.t()) :: {:ok, Team.t()}

  @callback find(team_id()) :: Team.t() | nil

  @callback find_by_slug(slug()) :: Team.t() | nil

  @callback find_all() :: list(Team.t())

  @callback update(team_id(), map()) :: {:ok, Team.t()}

  @callback delete(team_id()) :: {:ok}

  @callback add_member(Team.t(), Member.t()) :: {:ok, Team.t()}

  @callback add_task(Team.t(), task_name()) :: {:ok, Team.t()}

  @callback assign_member_to_task(Team.t(), Assignment.t()) :: {:ok, Team.t()}

  @callback unassign_member_from_task(Team.t(), Assignment.t()) :: {:ok, Team.t()}
end