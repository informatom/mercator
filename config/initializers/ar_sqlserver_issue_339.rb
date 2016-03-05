# update to 4.2. requires that additional fix according to:
# https://github.com/rails-sqlserver/activerecord-sqlserver-adapter/issues/381#issuecomment-76366715
if ActiveRecord::Base.connection.class.name.match(/SQLServerAdapter/)
  ActiveRecord::ConnectionAdapters::SQLServerAdapter.use_output_inserted = true
end
