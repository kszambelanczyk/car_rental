defmodule CarRentalTest do
  use CarRental.Case
  doctest CarRental

  test "greets the world" do
    assert CarRental.hello() == :world
  end
end
