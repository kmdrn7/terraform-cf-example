######################################################################
# DNS Locations: example-office
######################################################################

resource "cloudflare_teams_location" "example-office" {
  name           = "example-office"
  account_id     = var.cloudflare_account_id
  client_default = false
}

######################################################################
# Argo Tunnel: example-tunnel-nonprod
######################################################################

resource "cloudflare_argo_tunnel" "tunnel_nonprod" {
  account_id = var.cloudflare_account_id
  name       = "tunnel-nonprod"
  secret     = ""
}

resource "cloudflare_tunnel_route" "tunnel_routes" {
  account_id = var.cloudflare_account_id
  tunnel_id  = cloudflare_argo_tunnel.tunnel_nonprod.id

  count   = length(var.cloudflare_tunnel_routes) != 0 ? length(var.cloudflare_tunnel_routes) : 0
  network = var.cloudflare_tunnel_routes[count.index].network
  comment = var.cloudflare_tunnel_routes[count.index].comment
}

######################################################################
# Local Domain Fallback: tunnel-baru
######################################################################

resource "cloudflare_fallback_domain" "fallback_domain" {
  account_id = var.cloudflare_account_id
  policy_id  = var.cloudflare_account_id
  domains {
    suffix      = "example-dev.lokal"
    description = ""
    dns_server  = ["10.10.0.10"]
  }
  domains {
    suffix      = "example-dev2.lokal"
    description = ""
    dns_server  = ["10.10.4.10"]
  }
  # default domains by cloudflare warp
  dynamic "domains" {
    for_each = toset(["corp", "domain", "home", "home.arpa", "host", "internal", "intranet", "invalid", "lan", "local", "localdomain", "localhost", "private", "test"])
    content {
      suffix = domains.value
    }
  }
}

######################################################################
# Split Tunnel: tunnel-baru
######################################################################

# Including *.example.com in WARP routes
resource "cloudflare_split_tunnel" "split_tunnel" {
  account_id = var.cloudflare_account_id
  policy_id  = var.cloudflare_account_id
  mode       = "include"
  tunnels {
    host        = "help.teams.cloudflare.com"
    description = ""
  }
  tunnels {
    host        = "www.whatismyip.com"
    description = ""
  }
  tunnels {
    host        = "*.example-dev.lokal"
    description = "example-dev-dns"
  }
  tunnels {
    host        = "*.example-dev2.lokal"
    description = "example-dev2-dns"
  }
}
