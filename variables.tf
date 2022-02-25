variable "resource_group_name" {
}

variable "user_name" {
}

variable "disk_size" {
  default = "Standard_B1s" 
}

variable "pub_key" {
  default = "~/.ssh/id_rsa.pub"
}

variable "pvt_key" {
  default = "~/.ssh/id_rsa"
}

variable "ansible_key" {
  default = "~/.ssh/ansible.pub"
}

variable "count_servers" {
  default = 3
} 

variable "dns_prefix" {
  default = "public-nofit"
}