defmodule :"Elixir.PairDance.Infrastructure.Repo.Migrations.Make-email-unique" do
  use Ecto.Migration

  def change do
    create unique_index(:users, [:email])
  end
end
