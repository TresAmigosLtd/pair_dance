defmodule PairDanceWeb.AppLive.TeamPage do
  use PairDanceWeb, :live_view

  alias PairDance.Infrastructure.Team.EctoRepository, as: TeamRepository

  @impl true
  def mount(%{"slug" => slug}, session, socket) do
    team = TeamRepository.find_by_slug?(slug)
    user = session["current_user"]

    assigns =
      socket
      |> assign(:team, team)
      |> assign(:current_user, user)
      |> assign(:page_title, "Team #{team.name}")

    {:ok, assigns}
  end

  @impl true
  def handle_event("create-task", %{}, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("delete_task", %{"task_id" => task_id}, socket) do
    team = socket.assigns.team
    task = Enum.find(team.tasks, fn task -> task.id == String.to_integer(task_id) end)

    {:ok, updated_team} = TeamRepository.delete_task(team, task)

    {:noreply,
     socket
     |> assign(:team, updated_team)}
  end

  @impl true
  def handle_info({:team_changed, team}, socket) do
    {:noreply, assign(socket, :team, team)}
  end
end
