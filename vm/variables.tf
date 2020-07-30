variable "prefix" {
  type        = string
  description = "Env prefix for most resources"
}

variable "email" {
  type        = string
  description = "email address "
}
variable "location" {
  type        = string
  description = "Azure region "
}

variable "vm_vnet_cidr" {
  type        = string
  description = "Confiure the initial IP address for the VNET CIDR range of your Consul cluster. A prefix of /24 will be applied to the created VNET. VNET starting IP address must fall in the range of: 10.*.*.*, 172.[16-32].*.* or 192.168.*.*."
  default     = "172.25.17.0/24"
}

variable "public_key" {
  default = ""
}
variable "vm_size" {
  default = "Standard_D2s_v3"
}

variable "consul_download_url" {
  default = "https://releases.hashicorp.com/consul/1.8.0/consul_1.8.0_linux_amd64.zip"
}