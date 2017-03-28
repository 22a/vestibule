defmodule Vestibule.ContestController do
  use Vestibule.Web, :controller

  alias Vestibule.Contest
  import Vestibule.Authorisation

  plug :authorize when not action in [:index, :show]

  def index(conn, _params) do
    contests = Repo.all(Contest)
               |> Enum.map(fn(contest)->Map.put(contest, :active, active?(contest))end)
    render(conn, "index.html", contests: contests)
  end

  def new(conn, _params) do
    changeset = Contest.changeset(%Contest{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"contest" => contest_params}) do
    changeset = Contest.changeset(%Contest{}, contest_params)

    case Repo.insert(changeset) do
      {:ok, _contest} ->
        conn
        |> put_flash(:info, "Contest created successfully.")
        |> redirect(to: contest_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    contest = Repo.get!(Contest, id)
    problems = Repo.all(assoc(contest, :problems))
    render(conn, "show.html", contest: contest, problems: problems)
  end

  def edit(conn, %{"id" => id}) do
    contest = Repo.get!(Contest, id)
    changeset = Contest.changeset(contest)
    render(conn, "edit.html", contest: contest, changeset: changeset)
  end

  def update(conn, %{"id" => id, "contest" => contest_params}) do
    contest = Repo.get!(Contest, id)
    changeset = Contest.changeset(contest, contest_params)

    case Repo.update(changeset) do
      {:ok, contest} ->
        conn
        |> put_flash(:info, "Contest updated successfully.")
        |> redirect(to: contest_path(conn, :show, contest))
      {:error, changeset} ->
        render(conn, "edit.html", contest: contest, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    contest = Repo.get!(Contest, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(contest)

    conn
    |> put_flash(:info, "Contest deleted successfully.")
    |> redirect(to: contest_path(conn, :index))
  end

  defp active?(contest) do
    now = Ecto.DateTime.utc

    :gt != Ecto.DateTime.compare(contest.activate_time,now) and
    :lt != Ecto.DateTime.compare(contest.deactivate_time,now)
  end
end
