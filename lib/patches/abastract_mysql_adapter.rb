class ActiveRecord::ConnectionAdapters::Mysql2Adapter #ActiveRecord::ConnectionAdapters::AbstractMysqlAdapter
  NATIVE_DATABASE_TYPES[:primary_key] = "int(11) auto_increment PRIMARY KEY"
end

