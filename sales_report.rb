require 'minitest/autorun'

class SalesReport
  def run
    sales = [
      { rep: "Jamie", region: "North East", revenue: "80_000" },
      { rep: "Sam", region: "North East", revenue: "50_000" },
      { rep: "Charlie", region: "Midwest", revenue: "90_000" },
      { rep: "Sam", region: "North East", revenue: "10_000" },
    ]

    # 2. This is the main computation bit of the current report, and
    # it seems like we'll need to add more computation logic to suppor
    # the new requirement. While this bit is aesthetically atrocious,
    # it's functional. Its readability is poor, but so far as the
    # system is concerned it computes the correct values for the
    # report and it is not immediately clear this NEEDS to change to
    # accept the new requirement. This section is NOT a primary
    # concern for me at this point.
    regional_revenue = Hash.new(0)
    for rep in sales
      regional_revenue[rep.fetch(:region)] += rep.fetch(:revenue).to_i
    end

    # 1. The report currently consists of ONLY the regional revenue. This is the most obvious site which needs to change
    regional_revenue
  end
end

class SalesReportTest < Minitest::Test
  def test_run
    expected = {"North East"=>140000, "Midwest"=>90000}
    actual = SalesReport.new.run

    assert_equal expected, actual
  end
end

# >> Run options: --seed 12117
# >>
# >> # Running:
# >>
# >> .
# >>
# >> Finished in 0.000326s, 3067.4849 runs/s, 3067.4849 assertions/s.
# >>
# >> 1 runs, 1 assertions, 0 failures, 0 errors, 0 skips
