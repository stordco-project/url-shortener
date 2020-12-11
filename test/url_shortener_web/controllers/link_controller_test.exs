defmodule UrlShortenerWeb.LinkControllerTest do
  use UrlShortenerWeb.ConnCase, async: true

  alias UrlShortener.Link

  describe "show" do
    test "returns a 404 if the short link does not exist", %{conn: conn} do
      conn = get(conn, "/foobar")

      assert html_response(conn, 404)
    end

    test "redirects to the full url", %{conn: conn} do
      Repo.insert(%Link{url: "https://example.com", slug: "foobar"})

      conn = get(conn, "/foobar")

      assert redirected_to(conn) == "https://example.com"
    end
  end

  describe "create" do
    test "fails to create if no url is given", %{conn: conn} do
      conn = post(conn, "/", %{"link" => %{"url" => ""}})

      assert json_response(conn, 400) == %{
               "status" => "error",
               "message" => "url can't be blank"
             }
    end

    test "fails to create if no url is invalid", %{conn: conn} do
      conn = post(conn, "/", %{"link" => %{"url" => "asdf"}})

      assert json_response(conn, 400) == %{
               "status" => "error",
               "message" => "url must be a url"
             }
    end

    test "creates a link", %{conn: conn} do
      assert resp =
               conn
               |> post("/", %{"link" => %{"url" => "https://example.com"}})
               |> json_response(201)

      assert link = Repo.one(Link)

      assert resp == %{
               "status" => "success",
               "message" => Routes.link_url(@endpoint, :show, link.slug)
             }
    end
  end
end
