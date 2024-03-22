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

  def avg_per_rep_by_region
    transactions
      .group_by { |transaction| transaction.fetch(:region) }
      .transform_values do |regional_transactions|
        rep_count = regional_transactions.group_by { |transaction| transaction.fetch(:rep) }.count
        regional_total = total_by_region.fetch(regional_transactions.first.fetch(:region))

        regional_total / rep_count
      end
  end

  private

  attr_writer(
    :transactions,
  )
end

class SalesReportTest < Minitest::Test
  def test_run
    expected = {
      "total" => {
        "North East"=>140000,
        "Midwest"=>90000
      },
     }
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

  def test_avg_per_rep_by_region
    transactions = [
      { rep: "Jamie", region: "North East", revenue: "10" },
      { rep: "Sam", region: "North East", revenue: "10" },
      { rep: "Charlie", region: "Midwest", revenue: "20" },
      { rep: "Sam", region: "North East", revenue: "10" },
    ]
    expected = {
      "North East"=> 15,
      "Midwest"=>20,
    }

    actual = Ledger.new(transactions).avg_per_rep_by_region

    assert_equal expected, actual
  end
end

# >> Run options: --seed 65315
# >>
# >> # Running:
# >>
# >> ...
# >>
# >> Finished in 0.000503s, 5964.2148 runs/s, 5964.2148 assertions/s.
# >>
# >> 3 runs, 3 assertions, 0 failures, 0 errors, 0 skips
