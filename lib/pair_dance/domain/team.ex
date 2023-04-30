defmodule PairDance.Domain.Team do

  alias PairDance.Domain.TeamMember

  @enforce_keys [:id, :name, :members]
  defstruct [:id, :name, :members]

  @type t() :: %__MODULE__{
    id: integer(),
    name: String.t(),
    members: list(TeamMember.t())
  }
end
