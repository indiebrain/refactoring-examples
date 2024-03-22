require 'minitest/autorun'

class SalesReport
  def run
    ledger = Ledger.new([
      { rep: "Jamie", region: "North East", revenue: "80_000" },
      { rep: "Sam", region: "North East", revenue: "50_000" },
      { rep: "Charlie", region: "Midwest", revenue: "90_000" },
      { rep: "Sam", region: "North East", revenue: "10_000" },
    ])

    # [mf-refactoring 115] Inline function
    # 1. Find all the callers of the function.
    # 2. Replace each call with the function’s body.
    ledger.total_by_region
  end

  private

  def total_by_region(ledger)
    ledger.total_by_region
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

  def total_by_region
      transactions
      .group_by { |transaction| transaction.fetch(:region) }
      .transform_values { |transactions| transactions.sum { |transaction| transaction.fetch(:revenue).to_i } }
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

# >> Run options: --seed 18923
# >>
# >> # Running:
# >>
# >> .
# >>
# >> Finished in 0.000318s, 3144.6540 runs/s, 3144.6540 assertions/s.
# >>
# >> 1 runs, 1 assertions, 0 failures, 0 errors, 0 skips
