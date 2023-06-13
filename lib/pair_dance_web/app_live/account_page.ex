defmodule PairDanceWeb.AppLive.AccountPage do
  use PairDanceWeb, :live_view
  import PairDanceWeb.Auth.AuthHelpers

  @impl true
  def mount(_params, session, socket) do
    assigns =
      assign_user(socket, session)
      |> assign(:page_title, "Your Account")

    {:ok, assigns}
  end
end