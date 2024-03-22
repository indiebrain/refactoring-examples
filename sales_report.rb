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
  def total_by_region
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
# >> Run options: --seed 36812
# >>
# >> # Running:
# >>
# >> .
# >>
# >> Finished in 0.000267s, 3745.3184 runs/s, 3745.3184 assertions/s.
# >>
# >> 1 runs, 1 assertions, 0 failures, 0 errors, 0 skips
