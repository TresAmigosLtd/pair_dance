defmodule PairDance.Domain.Insights.Report do
  alias PairDance.Domain.Insights.Report.Activity
  alias PairDance.Domain.Insights.Report.Pairing

  def generate_report(all_assignments) do
    all_tasks = all_assignments |> Enum.map(fn assignment -> assignment.task end) |> Enum.uniq()

    task_activities =
      all_assignments
      |> Enum.group_by(fn assignment -> assignment.task.id end)
      |> Enum.map(fn {task_id, assignments} ->
        task = all_tasks |> Enum.find(fn x -> x.id == task_id end)
        calculate(task, assignments)
      end)

    #  returns a map of user_id => [user_id] of all pairings
    user_activities =
      Enum.flat_map(task_activities, fn activity -> activity.pairings end)
      |> Enum.reduce(%{}, fn %Pairing{pair1: pair1, pair2: pair2}, acc ->
        acc
        |> Map.put("#{pair1.id}", Map.get(acc, "#{pair1.id}", []) ++ [pair2.id])
        |> Map.put("#{pair2.id}", Map.get(acc, "#{pair2.id}", []) ++ [pair1.id])
      end)

    %{task_activities: task_activities, user_activities: user_activities}
  end

  defp calculate(task, assignments) do
    sorted_assignments = assignments |> Enum.sort_by(fn assignment -> assignment.time_range end)

    if length(assignments) == 1 do
      aggregate_findings(task, [], [Enum.at(assignments, 0).member])
    else
      findings =
        sorted_assignments
        |> Enum.with_index()
        |> Enum.reduce(%{pairings: [], involved_members: []}, fn {t1, index}, acc ->
          other_assignments = sublist(sorted_assignments, index)

          case length(other_assignments) do
            0 ->
              acc

            _ ->
              pairings = extract_pairings(t1, other_assignments)
              involved_members = extract_members(t1, other_assignments)

              %{
                pairings: acc.pairings ++ pairings,
                involved_members: (acc.involved_members ++ involved_members) |> Enum.uniq()
              }
          end
        end)

      aggregate_findings(
        task,
        findings.pairings,
        findings.involved_members
      )
    end
  end

  defp extract_members(t1, assignments) do
    Enum.reduce(assignments, [], fn t2, acc ->
      Enum.uniq([t1.member, t2.member | acc])
    end)
  end

  defp extract_pairings(t1, assignments) do
    Enum.reduce(assignments, [], fn t2, acc ->
      if is_overlap(t1.time_range, t2.time_range) do
        [
          %Pairing{
            pair1: t1.member,
            pair2: t2.member,
            duration_days: calculate_overlap_days(t1.time_range, t2.time_range)
          }
          | acc
        ]
      else
        acc
      end
    end)
  end

  # Returns a sublist of a list, excluding the first element.
  defp sublist(list, index) do
    assignment_count = length(list)
    max_index = assignment_count - 1

    Enum.slice(
      list,
      min(assignment_count, index + 1),
      max_index
    )
  end

  defp aggregate_findings(task, member_pairings, members) do
    %Activity{
      task: task,
      pairings: member_pairings,
      involved_members: members
    }
  end

  defp is_overlap(t1, t2) do
    intervals = normalize_intervals(t1, t2)

    intervals.t1_start <= intervals.t2_end && intervals.t2_start <= intervals.t1_end
  end

  defp calculate_overlap_days(t1, t2) do
    intervals = normalize_intervals(t1, t2)
    start_interval = max(intervals.t1_start, intervals.t2_start)
    end_interval = min(intervals.t1_end, intervals.t2_end)

    Decimal.from_float(
      DateTime.diff(
        DateTime.from_unix!(end_interval),
        DateTime.from_unix!(start_interval)
      ) / 3600 / 24
    )
    |> Decimal.round()
    |> Decimal.to_integer()
  end

  defp normalize_intervals(t1, t2) do
    t1_start = DateTime.to_unix(t1.start)
    t2_start = DateTime.to_unix(t2.start)
    t1_end = DateTime.to_unix(if t1.end == nil, do: DateTime.utc_now(), else: t1.end)
    t2_end = DateTime.to_unix(if t2.end == nil, do: DateTime.utc_now(), else: t2.end)

    %{
      t1_start: t1_start,
      t2_start: t2_start,
      t1_end: t1_end,
      t2_end: t2_end
    }
  end
end
