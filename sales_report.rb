require 'minitest/autorun'

class SalesReport
  def run
    sales = [
    # [mf-refactoring 170] Encapsulate collection
      { rep: "Jamie", region: "North East", revenue: "80_000" },
      { rep: "Sam", region: "North East", revenue: "50_000" },
      { rep: "Charlie", region: "Midwest", revenue: "90_000" },
      { rep: "Sam", region: "North East", revenue: "10_000" },
    ]

    # [mf-refactoring 237] Remove Dead Code
    sales
      .group_by { |sale| sale.fetch(:region) }
      .transform_values { |sales| sales.sum { |sale| sale.fetch(:revenue).to_i } }
  end
end

# 1. Represent a collection of sales transactions
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

# >> Run options: --seed 42107
# >>
# >> # Running:
# >>
# >> .
# >>
# >> Finished in 0.000418s, 2392.3446 runs/s, 2392.3446 assertions/s.
# >>
# >> 1 runs, 1 assertions, 0 failures, 0 errors, 0 skips
