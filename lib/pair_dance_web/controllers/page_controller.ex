defmodule PairDanceWeb.PageController do
  use PairDanceWeb, :controller

  def index(conn, _params) do
    render(conn, :index, current_user: get_session(conn, :current_user))
  end
end
