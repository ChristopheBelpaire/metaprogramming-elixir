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
    Enum.each tests, fn {test_func, description} ->
      spawn(__MODULE__, :run_test, [test_func, description, module])
    end
  end

  def run_test(test_func, description, module) do
    case apply(module, test_func, []) do
      :ok             -> IO.write(".")
      {:fail, reason} -> IO.puts """
      ==============================
      FAILURE : #{description}
      ==============================
      #{reason}
      """
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
