require 'minitest/autorun'

class SalesReport
  def run
    ledger = Ledger.new([
      { rep: "Jamie", region: "North East", revenue: "80_000" },
      { rep: "Sam", region: "North East", revenue: "50_000" },
      { rep: "Charlie", region: "Midwest", revenue: "90_000" },
      { rep: "Sam", region: "North East", revenue: "10_000" },
    ])

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

class LedgerTest < Minitest::Test
  def test_total_by_region
    transactions = [
      { region: "North East", revenue: "2" },
      { region: "North East", revenue: "3" },
      { region: "Midwest", revenue: "3" },
      { region: "North East", revenue: "1" },
    ]
    expected = {
      "North East" => 6,
      "Midwest" => 3,
    }

    actual = Ledger.new(transactions).total_by_region

    assert_equal expected, actual
  end
end

# >> Run options: --seed 18806
# >>
# >> # Running:
# >>
# >> ..
# >>
# >> Finished in 0.000360s, 5555.5555 runs/s, 5555.5555 assertions/s.
# >>
# >> 2 runs, 2 assertions, 0 failures, 0 errors, 0 skips
