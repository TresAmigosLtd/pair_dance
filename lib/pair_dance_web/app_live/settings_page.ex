defmodule PairDanceWeb.AppLive.SettingsPage do
  use PairDanceWeb, :live_view

  alias PairDance.Infrastructure.Team.EctoRepository, as: TeamRepository
  alias PairDance.Infrastructure.EventBus

  @impl true
  def mount(%{"slug" => slug}, session, socket) do
    EventBus.subscribe()

    user = session["current_user"]
    team = TeamRepository.find_by_slug?(slug)

    assigns =
      socket
      |> assign(:team, team)
      |> assign(:current_user, user)
      |> assign(:page_title, "Settings")

    {:ok, assigns}
  end

  @impl true
  def handle_event("delete_member", params, socket) do
    team = socket.assigns.team
    member_id = String.to_integer(params["member_id"])
    member_to_be_deleted = Enum.find(team.members, fn member -> member.id == member_id end)

    {:ok, updated_team} = TeamRepository.delete_member(team, member_to_be_deleted)

    {:noreply, assign(socket, :team, updated_team)}
  end

  @impl true
  def handle_event("delete_team", _, socket) do
    team = socket.assigns.team

    {:ok} = TeamRepository.delete(team.descriptor.id)

    {:noreply, push_navigate(socket, to: "/")}
  end

  @impl true
  @doc """
  Handler receives broadcasts from various place where team state is updated. E.g. rotations changed, task added/deleted.
  It then checks whether the event is relevant for the currently viewed team page. If so, it updates the team state.
  """
  def handle_info(%{team: team}, socket) do
    if team.descriptor.id == socket.assigns.team.descriptor.id do
      {:noreply, assign(socket, :team, team)}
    else
      {:noreply, socket}
    end
  end
end
