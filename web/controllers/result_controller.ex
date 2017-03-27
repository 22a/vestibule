defmodule Vestibule.ResultController do
  use Vestibule.Web, :controller

  alias Vestibule.Result

  def index(conn, _params) do
    results = Repo.all(Result)
    render(conn, "index.html", results: results)
  end

  def new(conn, _params) do
    changeset = Result.changeset(%Result{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"result" => result_params}) do
    changeset = Result.changeset(%Result{}, result_params)

    case Repo.insert(changeset) do
      {:ok, _result} ->
        conn
        |> put_flash(:info, "Result created successfully.")
        |> redirect(to: result_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    result = Repo.get!(Result, id)
    render(conn, "show.html", result: result)
  end

  def edit(conn, %{"id" => id}) do
    result = Repo.get!(Result, id)
    changeset = Result.changeset(result)
    render(conn, "edit.html", result: result, changeset: changeset)
  end

  def update(conn, %{"id" => id, "result" => result_params}) do
    result = Repo.get!(Result, id)
    changeset = Result.changeset(result, result_params)

    case Repo.update(changeset) do
      {:ok, result} ->
        conn
        |> put_flash(:info, "Result updated successfully.")
        |> redirect(to: result_path(conn, :show, result))
      {:error, changeset} ->
        render(conn, "edit.html", result: result, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    result = Repo.get!(Result, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(result)

    conn
    |> put_flash(:info, "Result deleted successfully.")
    |> redirect(to: result_path(conn, :index))
  end
end
