defmodule PairDance.Domain.Team.Repository do
  alias PairDance.Domain.Team
  alias PairDance.Domain.Team.Member
  alias PairDance.Domain.Team.Task

  @type team_id :: integer
  @type member_id :: String.t()
  @type slug :: String.t()
  @type task_name :: String.t()
  @type external_id :: String.t()

  @callback create(String.t()) :: {:ok, Team.t()}

  @callback find(team_id()) :: Team.t() | nil

  @callback find_by_member(member_id()) :: list(Team.Descriptor.t())

  @callback find_by_slug?(slug()) :: Team.t() | nil

  @callback update(team_id(), map()) :: {:ok, Team.t()}

  @callback delete(team_id()) :: {:ok}

  @callback add_member(Team.t(), Member.t()) :: {:ok, Team.t()}

  @callback deactivate_member(Team.t(), Member.t()) :: {:ok, Team.t()}

  @callback activate_member(Team.t(), Member.t()) :: {:ok, Team.t()}

  @callback delete_member(Team.t(), Member.t()) :: {:ok, Team.t()}

  @callback add_task(Team.t(), task_name()) :: {:ok, Team.t()}

  @callback add_task(Team.t(), task_name(), external_id()) :: {:ok, Team.t()}

  @callback update_task(Team.t(), Task.Descriptor.t()) :: {:ok, Team.t()}

  @callback get_tasks(team_id()) :: {:ok, list(Task.t())}

  @callback delete_task(Team.t(), Task.Descriptor.t()) :: {:ok, Team.t()}

  @callback assign_member_to_task(Team.t(), Member.t(), Task.Descriptor.t()) :: {:ok, Team.t()}

  @callback unassign_member_from_task(Team.t(), Member.t(), Task.Descriptor.t()) ::
              {:ok, Team.t()}

  @callback unassign_member_from_all_tasks(Team.t(), Member.t()) :: {:ok, Team.t()}

  @callback mark_member_unavailable(Team.t(), Member.t()) :: {:ok, Team.t()}

  @callback mark_member_available(Team.t(), Member.t()) :: {:ok, Team.t()}
end
