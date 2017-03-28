defmodule Vestibule.AttemptController do
  use Vestibule.Web, :controller

  alias Vestibule.Attempt

  def index(conn, _params) do
    attempts = Repo.all(Attempt)
    render(conn, "index.html", attempts: attempts)
  end

  def new(conn, params) do
    changeset = case params do
      %{"problem_id" => problem_id } ->
        Attempt.changeset(%Attempt{problem_id: problem_id})
      _ ->
        Attempt.changeset(%Attempt{})
    end
    problems = Repo.all(Vestibule.Problem) |> Enum.map(&{&1.name, &1.id})
    render(conn, "new.html", changeset: changeset, problems: problems)
  end

  def create(conn, %{"attempt" => attempt_params}) do
    changeset = Attempt.changeset(%Attempt{}, attempt_params)

    case Repo.insert(changeset) do
      {:ok, _attempt} ->
        conn
        |> put_flash(:info, "Attempt created successfully.")
        |> redirect(to: attempt_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    attempt = Repo.get!(Attempt, id)
    render(conn, "show.html", attempt: attempt)
  end

  def edit(conn, %{"id" => id}) do
    attempt = Repo.get!(Attempt, id)
    changeset = Attempt.changeset(attempt)
    problems = Repo.all(Vestibule.Problem) |> Enum.map(&{&1.name, &1.id})
    render(conn, "edit.html", attempt: attempt, changeset: changeset, problems: problems)
  end

  def update(conn, %{"id" => id, "attempt" => attempt_params}) do
    attempt = Repo.get!(Attempt, id)
    changeset = Attempt.changeset(attempt, attempt_params)

    case Repo.update(changeset) do
      {:ok, attempt} ->
        conn
        |> put_flash(:info, "Attempt updated successfully.")
        |> redirect(to: attempt_path(conn, :show, attempt))
      {:error, changeset} ->
        render(conn, "edit.html", attempt: attempt, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    attempt = Repo.get!(Attempt, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(attempt)

    conn
    |> put_flash(:info, "Attempt deleted successfully.")
    |> redirect(to: attempt_path(conn, :index))
  end
end
