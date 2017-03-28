defmodule Vestibule.AttemptController do
  use Vestibule.Web, :controller

  alias Vestibule.Attempt
  import Vestibule.Authorisation

  plug :authorize when not action in [:index, :show, :new, :create]

  @languages ["python", "c", "bash"]

  def index(conn, _params) do
    if admin?(conn) do
      attempts = Repo.all(Attempt, preload: :result)
      render(conn, "index.html", attempts: attempts)
    else
      current_user_id = Coherence.current_user(conn).id
      user_attempts = Repo.all(from a in Attempt, where: a.user_id == ^current_user_id, preload: :result)
      render(conn, "index.html", attempts: user_attempts)
    end
  end

  def new(conn, params) do
    languages = @languages |> Enum.map(&{&1,&1})
    changeset = case params do
      %{"problem_id" => problem_id } ->
        Attempt.changeset(%Attempt{problem_id: problem_id})
      _ ->
        Attempt.changeset(%Attempt{})
    end
    problems = Repo.all(Vestibule.Problem) |> Enum.map(&{&1.name, &1.id})
    render(conn, "new.html", changeset: changeset, problems: problems, languages: languages)
  end

  def create(conn, %{"attempt" => attempt_params}) do
    unless valid_language?(attempt_params["language"]) do
      conn
      |> put_flash(:error, "Invalid language")
      |> redirect(to: page_path(conn, :index))
      |> halt
    else
      current_user = Coherence.current_user(conn)
      user_info = %{"user_id" => current_user.id, "team_id" => current_user.team_id}
      updated_attempt_params = Map.merge(attempt_params, user_info)
      changeset = Attempt.changeset(%Attempt{}, updated_attempt_params)

      case Repo.insert(changeset) do
        {:ok, _attempt} ->
          conn
          |> put_flash(:info, "Attempt created successfully.")
          |> redirect(to: attempt_path(conn, :index))
        {:error, changeset} ->
          render(conn, "new.html", changeset: changeset)
      end
    end
  end

  def show(conn, %{"id" => id}) do
    attempt = Repo.get!(Attempt, id, preload: :result)
    current_user_id = Coherence.current_user(conn).id
    current_user_is_admin = admin?(conn)

    case attempt.user_id do
      ^current_user_id ->
        render(conn, "show.html", attempt: attempt)
      _ ->
        if current_user_is_admin do
          render(conn, "show.html", attempt: attempt)
        else
          conn
          |> put_flash(:error, "Unauthorized")
          |> redirect(to: page_path(conn, :index))
          |> halt
        end
    end
  end

  def edit(conn, %{"id" => id}) do
    languages = @languages |> Enum.map(&{&1,&1})
    attempt = Repo.get!(Attempt, id)
    changeset = Attempt.changeset(attempt)
    problems = Repo.all(Vestibule.Problem) |> Enum.map(&{&1.name, &1.id})
    render(conn, "edit.html", attempt: attempt, changeset: changeset, problems: problems, languages: languages)
  end

  def update(conn, %{"id" => id, "attempt" => attempt_params}) do
    attempt = Repo.get!(Attempt, id)
    changeset = Attempt.changeset(attempt, attempt_params)

    unless valid_language?(attempt_params["language"]) do
      conn
      |> put_flash(:error, "Invalid language")
      |> redirect(to: page_path(conn, :index))
      |> halt
    else
      case Repo.update(changeset) do
        {:ok, attempt} ->
          conn
          |> put_flash(:info, "Attempt updated successfully.")
          |> redirect(to: attempt_path(conn, :show, attempt))
        {:error, changeset} ->
          render(conn, "edit.html", attempt: attempt, changeset: changeset)
      end
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

  defp valid_language?(lang) do
    Enum.member?(@languages, lang)
  end
end
