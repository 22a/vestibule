# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :vestibule,
  ecto_repos: [Vestibule.Repo]

# Configures the endpoint
config :vestibule, Vestibule.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "o0J91m0P8Y4mxOt+iizUhEsufr0ivVif7tjcdT2OqVx8j6yNz9AhsqudsYPrG50C",
  render_errors: [view: Vestibule.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Vestibule.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"

# %% Coherence Configuration %%   Don't remove this line
config :coherence,
  user_schema: Vestibule.User,
  repo: Vestibule.Repo,
  module: Vestibule,
  logged_out_url: "/",
  email_from_name: "Your Name",
  email_from_email: "yourname@example.com",
  opts: [:authenticatable, :recoverable, :lockable, :trackable, :unlockable_with_token, :confirmable, :registerable]

config :coherence, Vestibule.Coherence.Mailer,
  adapter: Swoosh.Adapters.Sendgrid,
  api_key: "your api key here"
# %% End Coherence Configuration %%
