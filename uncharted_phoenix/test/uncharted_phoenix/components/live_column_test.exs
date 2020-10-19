defmodule UnchartedPhoenix.LiveColumnComponentTest do
  alias Uncharted.BaseChart
  alias Uncharted.Axes.{BaseAxes, MagnitudeAxis}
  alias Uncharted.ColumnChart.Dataset
  alias Uncharted.Component
  alias UnchartedPhoenix.LiveColumnComponent
  import Phoenix.LiveViewTest
  use ExUnit.Case
  @endpoint Endpoint
  @axes %BaseAxes{
    magnitude_axis: %MagnitudeAxis{
      min: 0,
      max: 2500,
      grid_lines: &__MODULE__.grid_line_fun/2
    }
  }
  @configured_axes %BaseAxes{
    magnitude_axis: %MagnitudeAxis{
      min: 0,
      max: 2500,
      grid_lines: &__MODULE__.grid_line_fun/2,
      line_color: "red",
      line_width: 7
    }
  }
  @nondisplayed_axes %BaseAxes{
    magnitude_axis: %MagnitudeAxis{
      min: 0,
      max: 2500,
      grid_lines: &__MODULE__.grid_line_fun/2,
      line_color: "red",
      line_width: 7,
      display_lines: false
    }
  }
  @base_chart %BaseChart{title: "this title", dataset: %Dataset{axes: @axes, data: []}}
  @configured_graph_chart %BaseChart{dataset: %Dataset{axes: @configured_axes, data: []}}
  @nondisplayed_graph_chart %BaseChart{dataset: %Dataset{axes: @nondisplayed_axes, data: []}}

  describe "LiveColumnComponent" do
    test "renders" do
      assert render_component(LiveColumnComponent,
               chart: @base_chart,
               id: Component.id(@base_chart)
             ) =~
               ~s(data-testid="lc-live-column-component")
    end

    test "renders the chart's title" do
      assert render_component(LiveColumnComponent,
               chart: @base_chart,
               id: Component.id(@base_chart)
             ) =~ @base_chart.title
    end

    test "renders grid lines according to configuration" do
      assert render_component(LiveColumnComponent, chart: @configured_graph_chart) =~
               "stroke=\"red\""

      assert render_component(LiveColumnComponent, chart: @configured_graph_chart) =~
               "stroke-width=\"7px\""

      refute render_component(LiveColumnComponent, chart: @nondisplayed_graph_chart) =~
               "stroke=\"red\""

      refute render_component(LiveColumnComponent, chart: @nondisplayed_graph_chart) =~
               "stroke-width=\"7px\""
    end
  end

  def grid_line_fun({min, max}, _step) do
    Enum.take_every(min..max, 500)
  end
end
