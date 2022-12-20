defmodule PairDanceWeb.AuthController do
  use PairDanceWeb, :controller
  plug Ueberauth

  require Logger

  alias Ueberauth.Auth

  def request(conn, _params) do
    render(conn, :home, current_user: get_session(conn, :current_user))
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out!")
    |> clear_session()
    |> redirect(to: "/")
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
    |> redirect(to: "/")
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
        conn
        |> put_flash(:info, "Successfully authenticated.")
        |> put_session(:current_user, user)
        |> configure_session(renew: true)
        |> redirect(to: "/")

      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: "/")
    end
  end

  defp extract_user(%Auth{provider: :google} = auth) do
    case auth.info do
      nil ->
        {:error, "Login failed"}

      _ ->
        {:ok, %{id: auth.uid, name: auth.info.first_name, email: auth.info.email}}
    end
  end
end