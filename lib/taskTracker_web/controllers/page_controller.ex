defmodule TaskTrackerWeb.PageController do
  use TaskTrackerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
