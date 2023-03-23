import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :chat_bubbles, ChatBubblesWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "xx5mCZbmo/cbkjmdlamH0GOLQAj11zL4wTDWKyBzmim+EzT8lB/9nXalALq6g6g4",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
