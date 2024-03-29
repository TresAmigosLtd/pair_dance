defmodule PairDanceWeb.AuthController do
  use PairDanceWeb, :controller
  plug Ueberauth

  require Logger

  alias Ueberauth.Auth
  alias PairDance.Infrastructure.Jira.JiraService
  alias PairDance.Infrastructure.Team.EctoRepository, as: TeamRepository

  @redirect_url "/"

  def index(conn, _params) do
    render(conn, :index, current_user: get_session(conn, :current_user))
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out!")
    |> clear_session()
    |> redirect(to: @redirect_url)
  end

  def callback(
        %{
          assigns: %{
            ueberauth_failure: _fails
          }
        } = conn,
        _params
      ) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: @redirect_url)
  end

  def callback(
        %{
          assigns: %{
            ueberauth_auth: auth
          }
        } = conn,
        _params
      ) do
    case extract_user(auth) do
      {:ok, user} ->
        redirect_request_path = get_session(conn, :redirect_request_path)
        delete_session(conn, :redirect_request_path)

        conn
        |> put_flash(:info, "Successfully authenticated.")
        |> put_session(:current_user, user)
        |> configure_session(renew: true)
        |> redirect(to: redirect_request_path || "/")

      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: @redirect_url)
    end
  end

  def jira_callback(conn, params) do
    team_id = params["state"]
    auth_code = params["code"]

    team = TeamRepository.find(team_id)
    {:ok, _integration} = JiraService.connect(team.descriptor.id, auth_code)

    conn
    |> redirect(to: "/#{team.descriptor.slug}/settings")
  end

  # We need to define the request call back to enable E2E tests.
  if Mix.env() == :test do
    def request(conn, params) do
      callback(conn, params)
    end
  end

  defp extract_user(%Auth{provider: :google} = auth) do
    case auth.info do
      nil ->
        {:error, "Login failed"}

      _ ->
        user =
          PairDance.Domain.User.LoginService.login(
            auth.info.email,
            auth.info.name,
            auth.info.image
          )

        {:ok, user}
    end
  end
end
