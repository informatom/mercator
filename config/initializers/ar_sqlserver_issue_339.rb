module ActiveRecord
  module ConnectionAdapters
    module Sqlserver
      module DatabaseStatements

        def sql_for_insert(sql, pk, id_value, sequence_name, binds)
          ["#{sql}; SELECT CAST(SCOPE_IDENTITY() AS bigint) AS Ident", binds]
        end

      end
    end
  end
end