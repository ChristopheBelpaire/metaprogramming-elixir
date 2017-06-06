defmodule Assertion do
  defmacro __using__(_options) do
    quote do
      import unquote(__MODULE__)
      Module.register_attribute __MODULE__, :tests, accumulate: true
      @before_compile unquote(__MODULE__)
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def run do
        Assertion.Test.run(@tests, __MODULE__)
      end
    end
  end

  defmacro test(description, do: test_block) do
    test_func = String.to_atom(description)
    quote do
      @tests {unquote(test_func), unquote(description)}
      def unquote(test_func)(), do: unquote(test_block)
    end
  end

  defmacro assert({operator, _, [lhs, rhs]}) do
    quote bind_quoted: [operator: operator, lhs: lhs, rhs: rhs] do
      Assertion.Test.assert(operator, lhs, rhs)
    end
  end

  defmacro assert(boolean) do
    quote bind_quoted: [boolean: boolean] do
      Assertion.Test.assert(boolean)
    end
  end

  defmacro refute({operator, _, [lhs, rhs]}) do
    quote bind_quoted: [operator: operator, lhs: lhs, rhs: rhs] do
      Assertion.Test.refute(operator, lhs, rhs)
    end
  end
end

defmodule Assertion.Test do

  def run(tests, module) do
    started_at = :erlang.system_time
    succeded =
    Enum.map(tests, fn {test_func, description} ->
      Task.async(__MODULE__, :run_test, [test_func, description, module])
    end)
    |> Enum.map(&Task.await/1)
    |> Enum.count(fn(result) -> result == :ok end)

    IO.puts """

    Tests passed in : #{(:erlang.system_time - started_at)/1000} milleseconds
    #{succeded}/#{Enum.count(tests)} passed
    """
  end

  def run_test(test_func, description, module) do
    case apply(module, test_func, []) do
      :ok ->
        IO.write(".")
        :ok
      {:fail, reason} ->
        IO.puts """
        ==============================
        FAILURE : #{description}
        ==============================
        #{reason}
        """
        :fail
    end
  end


  def assert(:==, lhs, rhs) when lhs == rhs do
    :ok
  end
  def assert(:==, lhs, rhs) do
    {:fail, """
    Expected:        #{lhs}
    to be equals to: #{rhs}
    """}
  end

  def refute(:==, lhs, rhs) when lhs == rhs do
    {:fail, """
    Expected:        #{lhs}
    to be equals to: #{rhs}
    """}
  end
  def refute(:==, lhs, rhs) do
    :ok
  end

  def assert(:!=, lhs, rhs) when lhs != rhs do
    :ok
  end
  def assert(:!=, lhs, rhs) do
    {:fail, """
    Expected:        #{lhs}
    to be not equals to: #{rhs}
    """}
  end

  def assert(:>, lhs, rhs) when lhs > rhs do
    :ok
  end
  def assert(:>, lhs, rhs) do
    {:fail, """
    Expected:        #{lhs}
    to be greater to: #{rhs}
    """}
  end

  def assert(:<, lhs, rhs) when lhs < rhs do
    :ok
  end
  def assert(:<, lhs, rhs) do
    {:fail, """
    Expected:        #{lhs}
    to be lower to: #{rhs}
    """}
  end

  def assert(true) do
    :ok
  end
  def assert(false) do
     {:fail, """
    Expected true value
    """}
  end
end
