defmodule UrlShortenerWeb.LinkController do
  use UrlShortenerWeb, :controller
  alias UrlShortener.Link

  def show(conn, %{"slug" => slug}) do
    with {:ok, link} <- Link.get(slug) do
      conn
      |> redirect(external: link.url)
    else
      {:error, :not_found} ->
        conn
        |> put_status(404)
        |> render("404.html")
    end
  end

  def create(conn, %{"link" => link_params}) do
    with {:ok, link} <- Link.create(link_params) do
      conn
      |> put_status(201)
      |> json(%{
        status: "success",
        message: Routes.link_url(conn, :show, link.slug)
      })
    else
      {:error, changeset} ->
        conn
        |> put_status(400)
        |> json(%{
          status: "error",
          message: UrlShortenerWeb.ErrorHelpers.error_message(changeset, :url)
        })
    end
  end
end
