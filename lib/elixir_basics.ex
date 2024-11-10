defmodule Membership do
  defstruct [:type, :price]
end

defmodule User do
  defstruct [:name, :membership]
end

defmodule ElixirBasics do
  use Application
  require Integer
  # external import
  alias UUID

  @y 15 # integer

  def start(_type, _args) do
    ElixirBasics.hello_world()
    # ElixirBasics.uuids()
    # ElixirBasics.strings()
    # ElixirBasics.numbers()
    # ElixirBasics.atoms()
    # ElixirBasics.conditionals()
    # ElixirBasics.dates()
    # ElixirBasics.tuples()
    # ElixirBasics.lists()
    # ElixirBasics.maps()
    # ElixirBasics.structs()
    # ElixirBasics.guessing_game()
    # ElixirBasics.get_nums()
    Supervisor.start_link([], strategy: :one_for_one)
  end

  def hello_world do
    IO.puts("Hello world")
  end

  def uuids do
    IO.puts(UUID.uuid4())
  end

  def strings do
    IO.puts("printed")
    IO.puts("New\nLine\n")
    IO.puts("Interpolation looks like \#{}\n")
    IO.puts("Unicode for a: #{?a}")
    IO.puts("String" <> " concatenation")
  end

  def numbers do
    x = 5.0 # float
    IO.puts(x)
    IO.puts(@y)
    IO.puts(x + @y)
  end

  def atoms do
    IO.puts(:world)
    IO.puts(:"hello world")
  end

  def conditionals do
    # random selection from the list
    z = Enum.random([13,14,15])
    if z === 15 do
      IO.puts(:true)
    else
      IO.puts(:false)
    end

    case z do
      13 -> IO.puts("Is thirteen #{z}")
      14 -> IO.puts("Is fourteen #{z}")
      15 -> IO.puts("Is same as @y")
    end
  end

  def dates do
    time = Time.new!(0,0,0,0)
    date = Date.new!(2025,1,1)
    date_time = DateTime.new!(date, time, "Etc/UTC")
    IO.inspect(date_time)
    # time difference in seconds
    time_till = DateTime.diff(date_time, DateTime.utc_now())
    days = div(time_till, 86400)
    # _ can be used as it makes the number more readable
    hours = div(rem(time_till,86_400), 3600)
    minutes = div(rem(time_till,3600), 60)
    seconds = rem(time_till,60)
    IO.puts("Time until new year #{days} days, #{hours} hours, #{minutes} minutes, #{seconds} seconds")
  end

  def tuples do
    first_and_second_place_medals = {:gold, :silver}
    medals = Tuple.append(first_and_second_place_medals,:bronze)
    IO.inspect(medals)
    prices = {5,12,31}
    avg_price = Tuple.sum(prices)/ tuple_size(prices)
    IO.puts("Avg price for #{elem(medals, 0)}, #{elem(medals, 1)} and #{elem(medals, 2)} is #{avg_price}")
    user = {"Zo", UUID.uuid4()}
    # destructuring
    {name, uid} = user
    IO.puts("#{name} has ID #{uid}")
  end

  def lists do
    users = [{"Ed", UUID.uuid4()},{"Edd", UUID.uuid4()},{"Eddy", UUID.uuid4()}]
    Enum.each(users, fn {name, uid} ->
      IO.puts("#{name} has ID #{uid}")
    end)

    nums = [25,50,75,100]
    for n <- nums, do: IO.puts(n)
    # add 5 to each element
    add_5 = for n <- nums, do: n + 5
    IO.inspect(add_5)
    # append to the end
    append_nums = add_5 ++ [45,125]
    # prepend to the start
    prepend_nums = [10, 15 | append_nums]
    IO.inspect(prepend_nums)
    # filter out odd numbers and square what is left
    even_nums = for n <- prepend_nums, Integer.is_even(n), do: n * n
    IO.inspect(even_nums)

    # Use Enum
    Enum.each(nums, fn num ->
      IO.puts("The number is #{num}")
    end)
    quadruple = Enum.map(nums, fn num -> num * 4 end)
    IO.inspect(quadruple)
    # Using anonymous functions
    stringify = Enum.map(nums, &Integer.to_string/1)
    IO.inspect(stringify)
    IO.inspect(sum_and_average(quadruple))
    IO.inspect(print_nums(quadruple))
  end

  def sum_and_average(nums) do
    sum = Enum.sum(nums)
    avg = sum / Enum.count(nums)
    {sum, avg}
  end

  def print_nums(nums) do
    nums |> Enum.join(", ") |> IO.puts()
  end

  def get_nums do
    IO.puts("Enter numbers separated by spaces: ")
    user_input = IO.gets("") |> String.trim()
    result = String.split(user_input, " ") |> Enum.map(&String.to_integer/1)
    {sum, avg} = sum_and_average(result)
    IO.puts("SUM: #{sum}, AVG: #{avg}")
  end

  def maps do
    digits = %{one: 1, two: 2, three: 3, four: 4, five: 5, six: 6, seven: 7, eight: 8, nine: 9}
    IO.puts(digits[:one])
    IO.puts(digits.two)
  end

  def structs do
    gold_membership = %Membership{type: :gold, price: 25}
    silver_membership = %Membership{type: :silver, price: 20}
    bronze_membership = %Membership{type: :bronze, price: 10}

    users = [%User{name: "Ed", membership: gold_membership},%User{name: "Edd", membership: silver_membership},%User{name: "Eddy", membership: bronze_membership}]
    Enum.each(users, fn %User{name: name, membership: membership} ->
      IO.puts("#{name} has a #{membership.type} of price #{membership.price}")
    end)
  end

  def guessing_game do
    # random number between 1 and 10
    correct = :rand.uniform(10)
    guess_1 = IO.gets("Guess a number between 1 and 10: ") |> String.trim()
    IO.puts("You guessed #{guess_1}, correct was #{correct}")
    if String.to_integer(guess_1) === correct do
      IO.puts("Pass")
    else
      IO.puts("Fail")
    end

    guess_2 = IO.gets("Guess a number between 1 and 10: ") |> String.trim() |> Integer.parse()
    IO.inspect(guess_2)

    case guess_2 do
      {result, ""} -> IO.puts("Parsed successfull #{result}")
      {result, other} -> IO.puts("Parsed partially successfull #{result} #{other}")
      :error -> IO.puts("An error occurred")
    end

    guess_3 = IO.gets("Guess a number between 1 and 10: ") |> String.trim() |> Integer.parse()

    case guess_3 do
      {result, _} -> IO.puts("Parsed successfull #{result}")

      if guess_3 === correct do
        IO.puts("Pass")
      else
        IO.puts("Fail")
      end

      :error -> IO.puts("An error occurred")
    end
  end
end
