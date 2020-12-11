defmodule UrlShortener.Link do
  use Ecto.Schema
  import Ecto.Changeset

  import Ecto.Query, warn: false

  alias UrlShortener.Repo

  schema "links" do
    field :url, :string
    field :slug, :string

    timestamps()
  end

  @doc false
  def changeset(link, attrs) do
    link
    |> cast(attrs, [:url, :slug])
    |> validate_required([:url, :slug])
    |> validate_format(:url, ~r|http(s?)://|, message: "must be a url")
    |> unique_constraint(:slug, name: :links_slug_index)
  end

  def get(slug) do
    case Repo.get_by(__MODULE__, slug: slug) do
      nil ->
        {:error, :not_found}

      link ->
        {:ok, link}
    end
  end

  def create(params, opts \\ []) do
    slug = Keyword.get(opts, :slug, generate_slug())

    %__MODULE__{}
    |> changeset(params |> Map.put("slug", slug))
    |> Repo.insert()
    |> case do
      {:ok, link} ->
        {:ok, link}

      {:error, %Ecto.Changeset{errors: errors} = changeset} ->
        if slug_taken?(Keyword.get(errors, :slug)) do
          create(params, opts)
        else
          {:error, changeset}
        end
    end
  end

  defp slug_taken?({"has already been taken", _}), do: true
  defp slug_taken?(_), do: false

  defp generate_slug() do
    Stream.repeatedly(fn ->
      ?a..?z
      |> Enum.concat(?A..?Z)
      |> Enum.concat(?0..?9)
      |> Enum.random()
    end)
    |> Enum.take(5)
    |> to_string()
  end
end
