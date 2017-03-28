defmodule Vestibule.Authorisation do
  import Phoenix.Controller
  import Plug.Conn
  import Vestibule.Router.Helpers

  def admin?(conn) do
    case Coherence.current_user(conn) do
      nil -> false
      user -> user.is_admin
    end
  end

  def authorize(conn, _opts) do
    if admin? conn do
      conn
    else
      conn
      |> put_flash(:error, "Unauthorized")
      |> redirect(to: page_path(conn, :index))
      |> halt
    end
  end
end
