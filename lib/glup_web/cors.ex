defmodule GlupWeb.CORS do
  use Corsica.Router,
    origins: "*",
    allow_headers: ["content-type"],
    allow_credentials: true,
    max_age: 600

  resource("/login", origins: "*")
end
