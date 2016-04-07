class ExtentAccessionedReport < AbstractReport

  def self.report_opts
    @opts ||= {
      :uri_suffix => "extent_accessioned",
      :description => "See the extent of what was accessioned in a date range",
      :params => [["start_date", Date, "Start date"], ["end_date", Date, "End date"]]
    }

    @opts
  end

  register_report(self.report_opts)


  def initialize(params)
    super

    @start_date = Date.parse(params[:start_date].strftime("%Y-%m-%d"))
    @end_date = Date.parse(params[:end_date].strftime("%Y-%m-%d"))
  end


  def title
    "Data showing how much has been accessioned in a time period"
  end

  def headers
    %w(identifier title accession_date number extent_type container_summary)
  end

  def processor
    {
      'identifier' => proc {|record| ASUtils.json_parse(record[:identifier] || "[]").compact.join("-")},
      'extent_type' => proc {|record| record[:value]}
    }
  end

  def query(db)
    db[:accession].left_join(:extent, :accession_id => :id).left_join(:enumeration_value, :id => :extent_type_id).where(:number).where(:accession_date => (@start_date..@end_date)).order(Sequel.asc(:accession_date))
  end

end

