class Admin::StatsController < Admin::BaseController

  before_action { authorize! :read, :statistics }

  def entries
    @sources          = Source.visible.sort_by { |s| s.name }

    sql = if @current_source = @sources.find { |s| s.id == params[:source_id].to_i }
      @total_count = Entry.where(source_id: params[:source_id].to_i).count
      "SELECT COUNT(*), EXTRACT(MONTH FROM created_at) AS month, DATE(created_at) AS date FROM entries WHERE EXTRACT(YEAR FROM created_at)=#{ params[:year] } AND source_id=#{ params[:source_id].to_i } GROUP BY month, date ORDER BY date DESC"
    else
      @total_count = Entry.count
      "SELECT COUNT(*), EXTRACT(MONTH FROM created_at) AS month, DATE(created_at) AS date FROM entries WHERE EXTRACT(YEAR FROM created_at)=#{ params[:year] } GROUP BY month, date ORDER BY date DESC"
    end

    @entries_counters = ActiveRecord::Base.connection.execute sql
    @months           = @entries_counters.map { |e| e['month'] }.uniq
    @last_fetch_time  = Time.parse KeyValue.get 'stats:last_fetch_time'
  end

end
