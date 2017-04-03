defmodule Vestibule.AttemptController do
  use Vestibule.Web, :controller

  alias Vestibule.Attempt
  import Vestibule.Authorisation

  plug :authorize when not action in [:index, :new, :create]

  @languages ["python", "c", "bash"]

  def index(conn, _params) do
    if admin?(conn) do
      attempts = Repo.all(Attempt)
                 |> Repo.preload(:result)
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
        {:ok, attempt} ->
          {pass, output} = make_attempt(attempt_params)
          result = %{"result" => %{"attempt_id" => attempt.id, "pass" => pass, "output" => output}}
          Vestibule.ResultController.create(conn, result)
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

  defp make_attempt(params) do
    problem = Repo.get!(Vestibule.Problem, params["problem_id"])
    code = params["code"]
    language = params["language"]

    {:ok, %{exit_code: exit_code, output: output}} = caisson_execute(code, language)

    pass_string = to_string compare_output(problem.expected_output, output)

    {pass_string, output}
  end

  defp compare_output(expected_output, output) do
    IO.inspect(String.myers_difference(expected_output, output))
    stripped_expected_output = expected_output
                               |> String.replace("\n","")
    stripped_output = output
                      |> String.replace("\n","")
    stripped_expected_output == stripped_output
  end

  # TODO: move this caisson stuff out into its own module
  @caisson_execution_endpoint "http://127.0.0.1:4001/execute"
  @default_headers [{"Content-Type", "application/json"}]
  @default_timeout "1"
  @default_memory_limit "50"

  defp caisson_execute(code, lang) do
    payload_json = Poison.encode!(%{
      payload: code,
      lang: lang,
      timelimit: @default_timeout,
      memlimit: @default_memory_limit})

    case HTTPoison.post(@caisson_execution_endpoint, payload_json, @default_headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        %{"exit_status" => exit_code, "output" => output} = Poison.decode!(body)
        {:ok, %{ exit_code: exit_code, output: output}}

      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} ->
        {:error, %{ status: {:caisson_error, status_code}, body: body }}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, %{ status: {:http_error, reason} }}
    end
  end
end
