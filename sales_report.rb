require 'minitest/autorun'

class SalesReport
  def run
    sales = [
      { rep: "Jamie", region: "North East", revenue: "80_000" },
      { rep: "Sam", region: "North East", revenue: "50_000" },
      { rep: "Charlie", region: "Midwest", revenue: "90_000" },
      { rep: "Sam", region: "North East", revenue: "10_000" },
    ]

    # [mf-refactoring 137] Rename variable.
    result = Hash.new(0)
    for rep in sales
      result[rep.fetch(:region)] += rep.fetch(:revenue).to_i
    end

    result
  end
end

class SalesReportTest < Minitest::Test
  def test_run
    expected = {"North East"=>140000, "Midwest"=>90000}
    actual = SalesReport.new.run

    assert_equal expected, actual
  end
end

# >> Run options: --seed 45460
# >>
# >> # Running:
# >>
# >> .
# >>
# >> Finished in 0.000321s, 3115.2648 runs/s, 3115.2648 assertions/s.
# >>
# >> 1 runs, 1 assertions, 0 failures, 0 errors, 0 skips
