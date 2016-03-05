#module ActiveRecord
#  module ConnectionAdapters
#    module Sqlserver
#      module DatabaseStatements

#        def sql_for_insert(sql, pk, id_value, sequence_name, binds)
#          ["#{sql}; SELECT CAST(SCOPE_IDENTITY() AS bigint) AS Ident", binds]
#        end

# update to 4.2. requires that additional fix according to:
# https://github.com/rails-sqlserver/activerecord-sqlserver-adapter/issues/381#issuecomment-76366715
#        if ActiveRecord::Base.connection.class.name.match(/SQLServerAdapter/)
#          ActiveRecord::ConnectionAdapters::SQLServerAdapter.use_output_inserted = false
#        end

#      end
#    end
#  end
#end