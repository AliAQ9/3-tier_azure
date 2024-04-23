variable "name" {}
variable "location" {}
variable "vnet_name" {}
variable "security_group_name" {}
variable "websubnetname" {}
variable "appsubnetname" {}
variable "web_host_name" {}
variable "app_host_name"{}
variable "appsubnetcidr" {}
variable "websubnetcidr" {}
variable  "ruslan" {
    type = list
    default = ["ruslan1", "ruslan2", "ruslan3"]
}