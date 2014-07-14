class Admin::StatsController < Admin::BaseController

  def entries
    @sources = Source.visible.sort_by { |s| s.name }
    sql = if @current_source = @sources.find { |s| s.id == params[:source_id].to_i }
      "SELECT COUNT(*), EXTRACT(YEAR FROM created_at) AS year, DATE(created_at) AS date FROM entries WHERE source_id=#{ params[:source_id].to_i } GROUP BY year, date ORDER BY date DESC"
    else
      "SELECT COUNT(*), EXTRACT(YEAR FROM created_at) AS year, DATE(created_at) AS date FROM entries GROUP BY year, date ORDER BY date DESC"
    end
    @entries_counters = ActiveRecord::Base.connection.execute sql
    @years = @entries_counters.map { |e| e['year'] }.uniq
  end

end
