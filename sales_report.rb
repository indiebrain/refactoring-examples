require 'minitest/autorun'

class SalesReport
  def run
    ledger = Ledger.new([
      { rep: "Jamie", region: "North East", revenue: "80_000" },
      { rep: "Sam", region: "North East", revenue: "50_000" },
      { rep: "Charlie", region: "Midwest", revenue: "90_000" },
      { rep: "Sam", region: "North East", revenue: "10_000" },
    ])

    # [mf-refactoring 106] Extract function
    ledger
      .transactions
      .group_by { |transaction| transaction.fetch(:region) }
      .transform_values { |transactions| transactions.sum { |transaction| transaction.fetch(:revenue).to_i } }
  end

  private

  # 1. Copy the extracted code from the source function into the new target function.
  # 2.Scan the extracted code for references to any variables that are local in scope to the source function and will not be in scope for the extracted function. Pass them as parameters.
  def total_by_region(ledger)
    ledger
      .transactions
      .group_by { |transaction| transaction.fetch(:region) }
      .transform_values { |transactions| transactions.sum { |transaction| transaction.fetch(:revenue).to_i } }
  end
end

class Ledger
  def initialize(transactions)
    self.transactions = transactions
  end

  def add(transaction)
    self.transactions.push(transaction)
  end

  def transactions
    @transactions.dup
  end

  private

  attr_writer(
    :transactions,
  )
end

class SalesReportTest < Minitest::Test
  def test_run
    expected = {"North East"=>140000, "Midwest"=>90000}
    actual = SalesReport.new.run

    assert_equal expected, actual
  end
end
# >> Run options: --seed 25852
# >>
# >> # Running:
# >>
# >> .
# >>
# >> Finished in 0.000278s, 3597.1220 runs/s, 3597.1220 assertions/s.
# >>
# >> 1 runs, 1 assertions, 0 failures, 0 errors, 0 skips
