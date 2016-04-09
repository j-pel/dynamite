defmodule WebapiTest do
  use ExUnit.Case

	test "info from web api" do
		{:ok, %HTTPoison.Response{body: body}} = HTTPoison.get("http://omdbapi.com/?t=Magnolia",[{"User-agent", "Elixir"}])
		{:ok, info} = Poison.decode(body)
		assert info["Year"] == "1999"
	end
	
end
