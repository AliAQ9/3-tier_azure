variable "name" {}
variable "location" {}
variable "appsubnetcidr" {}
variable "dbsubnetcidr" {}
variable "websubnetcidr" {}
variable "virtual_network_name" {}
variable "UUID" {
    type = map(string)
}