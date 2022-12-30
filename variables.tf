variable "cloudflare_api_token" {
  type        = string
  description = "manage access and permission for your account"
}

variable "cloudflare_api_key" {
  type        = string
  description = "keys used to access cloudflare api"
}

variable "cloudflare_email" {
  type        = string
  description = "cloudflare account email"
}

variable "cloudflare_account_id" {
  type        = string
  description = "cloudflare account id"
}

variable "cloudflare_tunnel_routes" {
  type = list(object({
    network = string
    comment = string
  }))
}
