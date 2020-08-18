use Mix.Config

# Configure your database
config :database, Database.Repo,
  username: "postgres",
  password: "123",
  database: "database_cache_distribute_demo",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10
