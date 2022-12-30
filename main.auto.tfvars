cloudflare_api_token  = "CF_API_TOKEN"
cloudflare_api_key    = "CF_API_KEY"
cloudflare_account_id = "CF_ACCOUNT_ID"
cloudflare_email      = "mail@example.com"
cloudflare_tunnel_routes = [
  {
    network = "10.10.0.0/23"
    comment = "example-dev network"
  },
  {
    network = "10.10.4.0/23"
    comment = "example-dev2 network"
  },
]
