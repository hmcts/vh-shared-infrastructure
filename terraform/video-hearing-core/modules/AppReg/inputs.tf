variable "environment" {
    type = string
}

variable "app_conf" {
    type = map
}

variable "app_roles" {
    type = map
}

variable "api_permissions" {
    type = map
}

variable "resource_group_name" {
    type = string
}

variable "app_keyvaults_map" {
    type = map(any)
}

variable "tags" {
    type = map(any)
    default = {}
}