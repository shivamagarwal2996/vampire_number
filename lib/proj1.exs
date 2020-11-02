# Writing results to a file called results
# File.rm "results"
# {:ok, file_pid} = File.open "results", [:write]
# Process.register(file_pid, :file)

defmodule Benchmark do
  @moduledoc """
    Module takes a function as an argument and returns running time of the function
  """
  def measure(function) do
    function
    |> :timer.tc()
    |> elem(0)
    |> Kernel./(1_000_000)
  end
end

defmodule Registry do
  @moduledoc """
    Not crucial for computation of results.
    Implemented to keep track of number of actors alive and time them.
    This timing was later obsolete as we resorted to linux time command.
  """
  use GenServer
  # client APIs
  def start_link(num_actors) do
    GenServer.start_link(__MODULE__, num_actors)
  end

  def record_result(server, res) do
    GenServer.cast(server, {:record, res})
  end

  # server callbacks
  def init(num_actors) do
    # State stores number of active processes and running times of finished processes
    {:ok, %{num_actors: num_actors, result: []}}
  end

  def handle_cast({:record, res}, state) do
    result = state.result
    new_state = put_in(state.result, result ++ res)
    num_actors = state.num_actors
    num_actors = num_actors - 1
    new_state = put_in(new_state.num_actors, num_actors)

    # Once all processes have finished computation, the running times of these processes are sent to the daemon
    if(num_actors == 0) do
      send(:daemon, {:result, new_state.result})
    end

    {:noreply, new_state}
  end
end

defmodule Compute do
  def iterate({start, finish}) do
    list = Enum.map(start..finish, fn (x) -> isVampire(x) end)
    result = Enum.filter(list, & !is_nil(&1))
    result
  end

  def isVampire (number) do
    len = length(Integer.digits(number))
    if rem(len,2) == 0 do
      len2 = div(len,2)
      start = :math.pow(10, len2-1) |> round
      half = div(:math.pow(10, len2) |> round, 2)
      sqrt = :math.sqrt(number) |> round
      finish = min(half, sqrt)
      resResult = Enum.filter(start..finish, fn(x) -> rem(number,x) == 0 and isVamp(number, x, div(number,x)) and (rem(x,10) != 0 or rem(div(number,x), 10) != 0) end)
      if length(resResult) > 0 do
        res = Enum.map(resResult, fn (x) -> "#{x} #{div(number,x)} " end)

        "#{number} #{res}\n"
      end
    end
  end

  def isVamp(number, fac1, fac2) do
    numDigits = Integer.digits(number)
    numfac1 = Integer.digits(fac1)
    numfac2 = Integer.digits(fac2)
    numfacs = numfac1 ++ numfac2
    sortedList1 = Enum.sort(numDigits)
    sortedList2 = Enum.sort(numfacs)
    if sortedList1 == sortedList2 do
      true
    else
      false
    end
  end

  def spawn_actor(work_unit) do
    # IO.puts("Actor Spawned")
    # IO.inspect(work_unit)
    Task.async(fn -> res = Compute.iterate(work_unit)
        Registry.record_result(:registry, res)

    end)
  end
end

defmodule Main do
  def mainMethod(a,b) do
    num_actors = 8

    start_time = Time.utc_now()

    # Receiving command line arguments
    #[a, b] = System.argv()
    #{a, ""} = Integer.parse(a)
    #{b, ""} = Integer.parse(b)

    # To compute work_units for all processes, given number of actors. work_units are sets of sub-problems to be solved by actors.
    # Given n and num_actors, work_units are ranges we get by dividing 1 to n into num_actors sets.
    # Eg. n = 20, num_actors = 3; work_units = [{1, 7}, {8,14}, {15, 20}]
    size_of_work_unit = :math.ceil((b-a) / num_actors) |> Kernel.trunc()

    work_units =
      Enum.map(1..num_actors, fn i -> {a+(i - 1) * size_of_work_unit + 1, a+i * size_of_work_unit} end)

    {startLast, _} = List.last(work_units)
    work_units = List.replace_at(work_units, num_actors - 1, {startLast, b})
    # IO.inspect work_units

    # Init GenServer; Giving names for GenServer, Daemon
    {:ok, registry_pid} = Registry.start_link(num_actors)
    Process.register(self(), :daemon)
    Process.register(registry_pid, :registry)

    # Start the computation
    spawn_actor = &Compute.spawn_actor(&1)
    Enum.map(work_units, spawn_actor)

    # Receipt of message by the daemon from the GenServer symbolizes end of computation by the actors
    # Time computation obsolete as we are using linux time command. Therefore commenting it out.
    receive do
      {:result, result} ->
        IO.puts(result)
    end
  end
end
