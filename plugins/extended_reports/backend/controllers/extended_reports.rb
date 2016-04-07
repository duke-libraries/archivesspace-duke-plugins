class ArchivesSpaceService < Sinatra::Base

  include ReportHelper::ResponseHelpers

  Endpoint.get("/repositories/:repo_id/reports/#{ExtentAccessionedReport.report_opts[:uri_suffix]}")
    .description(ExtentAccessionedReport.report_opts[:description])
    .params(*(ExtentAccessionedReport.report_opts[:params] << ReportHelper.report_formats << ["repo_id", :repo_id]))
    .permissions([])
    .returns([200, "report"]) \
  do
    report_response(ExtentAccessionedReport.new(params), params[:format])
  end

end
