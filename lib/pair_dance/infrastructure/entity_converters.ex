defmodule PairDance.Infrastructure.EntityConverters do
  alias PairDance.Domain.Team.Assignment
  alias PairDance.Domain.Team.AssignedMember
  alias PairDance.Domain.Team.AssignedTask
  alias PairDance.Domain.Team
  alias PairDance.Domain.Team.Member
  alias PairDance.Domain.User
  alias PairDance.Domain.Team.Task
  alias PairDance.Domain.Team.TimeRange

  def to_team_descriptor(entity) do
    %Team.Descriptor{
      id: entity.id,
      name: entity.name,
      slug: entity.slug
    }
  end

  def to_member(entity) do
    %Member{
      id: entity.id,
      user: to_user(entity.user),
      role: :admin,
      available: entity.available,
      active: entity.active
    }
  end

  def to_member(member_entity, user_entity) do
    %Member{
      id: member_entity.id,
      user: to_user(user_entity),
      role: :admin,
      available: member_entity.available,
      active: member_entity.active
    }
  end

  def to_task_descriptor(entity) do
    %Task.Descriptor{
      id: entity.id,
      name: entity.name,
      is_imported: entity.external_id != nil,
      external_id: entity.external_id
    }
  end

  def to_user(entity) do
    %User{
      id: entity.id,
      email: entity.email,
      name: entity.name,
      approximate_name: Enum.at(String.split(entity.email, "@"), 0),
      avatar: entity.avatar,
      last_login: entity.last_login,
      last_active_team_id: entity.last_active_team_id,
      initials:
        case entity.name do
          nil -> nil
          _ -> User.Name.initials(entity.name)
        end
    }
  end

  def to_assignment(entity, member, task) do
    %Assignment{
      member: member,
      task: task,
      time_range: to_time_range(entity)
    }
  end

  def to_assigned_task(assignment_entity, task_entity) do
    %AssignedTask{
      task: to_task_descriptor(task_entity),
      time_range: to_time_range(assignment_entity)
    }
  end

  def to_assigned_member(assignment_entity, member_entity, user_entity) do
    %AssignedMember{
      member: %Member{
        id: member_entity.id,
        user: to_user(user_entity),
        role: :admin,
        available: member_entity.available
      },
      time_range: to_time_range(assignment_entity)
    }
  end

  def to_time_range(entity) do
    {:ok, start_time} = DateTime.from_naive(entity.inserted_at, "Etc/UTC")

    {:ok, end_time} =
      case entity.deleted_at do
        nil -> {:ok, nil}
        time -> DateTime.from_naive(time, "Etc/UTC")
      end

    %TimeRange{start: start_time, end: end_time}
  end
end
