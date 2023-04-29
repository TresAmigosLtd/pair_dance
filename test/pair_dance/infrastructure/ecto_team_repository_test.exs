defmodule PairDance.Infrastructure.EctoTeamRepositoryTest do
  use PairDance.DataCase

  alias PairDance.Domain.Team
  alias PairDance.Infrastructure.EctoTeamRepository

  test "create a team" do
    {:ok, team} = EctoTeamRepository.create("comet")

    assert team.name == "comet"
  end

  test "get a team by id" do
    {:ok, %Team{ id: id }} = EctoTeamRepository.create("comet")

    team = EctoTeamRepository.find(id)

    assert team != nil
    assert team.name == "comet"
  end


  test "get a non-existing team" do
    assert EctoTeamRepository.find(-1) == nil
  end

  test "list all teams" do
    {:ok, _} = EctoTeamRepository.create("team 1")
    {:ok, _} = EctoTeamRepository.create("team 2")

    [%Team{ name: name }, %Team{}] = EctoTeamRepository.find_all()

    assert String.starts_with?(name, "team")
  end

  test "delete a team" do
    {:ok, %Team{ id: id }} = EctoTeamRepository.create("comet")

    {:ok} = EctoTeamRepository.delete(id)

    assert EctoTeamRepository.find(id) == nil
  end

end
