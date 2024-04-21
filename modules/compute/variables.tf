variable "resource_group_name" {
  description = "The name of the resource group in which to create the VNET"
}

variable "location" {
  description = "The location/region where the resources will be provisioned"
}

variable "vnet_name" {
  description = "The name of the Virtual Network"
}

variable "subnet_names" {
  description = "A list of names for the subnets"
  type        = list(string)
}

variable "subnet_security_groups" {
  description = "A map of subnet names to security group names"
  type        = list(map(string))
}