resource "hcloud_server" "nas_vps" {
  name = "hermes-cx11"
  image = "debian-11"
  server_type = "cx11"
}