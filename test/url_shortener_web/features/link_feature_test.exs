defmodule UrlShortenerWeb.LinkFeatureTest do
  use ExUnit.Case
  use Wallaby.Feature
  alias UrlShortener.Link
  alias UrlShortenerWeb.Router.Helpers, as: Routes
  alias UrlShortener.Repo
  @endpoint UrlShortenerWeb.Endpoint

  feature "renders the 404 screen when we encounter an unknown link", %{session: session} do
    session
    |> visit("/foobar")
    |> assert_text("Looks like we don't know where that link goes")
  end

  feature "shows validation error when url is blank", %{session: session} do
    session
    |> visit("/")
    |> click(Query.button("Shrink!"))
    |> assert_text("Error!")
  end

  feature "shows validation error when url is not valid", %{session: session} do
    session
    |> visit("/")
    |> fill_in(Query.text_field("URL"), with: "example.com")
    |> click(Query.button("Shrink!"))
    |> assert_has(Query.css("input:invalid"))
  end

  feature "creates a shortened link", %{session: session} do
    session
    |> visit("/")
    |> fill_in(Query.text_field("URL"), with: "https://example.com")
    |> click(Query.button("Shrink!"))
    |> assert_text("Here is your microscopic link")

    link = Repo.one(Link)
    shortened_link_url = Routes.link_url(@endpoint, :show, link.slug)
    shortened_link_query = shortened_link_url |> Query.link()

    assert session
           |> assert_has(shortened_link_query)
           |> click(shortened_link_query)
           |> focus_window(
             session
             |> window_handles()
             |> List.last()
           )
           |> current_url() =~ link.url
  end

  feature "redirects from the shortened link to the full link", %{session: session} do
    {:ok, link} = Link.create(%{"url" => "https://example.com"})

    assert session
           |> visit(Routes.link_path(@endpoint, :show, link.slug))
           |> current_url() =~ link.url
  end
end
