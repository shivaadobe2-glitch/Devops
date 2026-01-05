variable "region"{
    description = "This is the default region"
    type = string
    default = "ap-south-2"
}

variable "cidr_blocks" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = [
    "172.31.48.0/24",
    "172.31.49.0/24",
    "172.31.50.0/24"
  ]
}

variable "availability_zones" {
  description = "Availability Zones"
  type        = list(string)
  default     = [
    "ap-south-2a",
    "ap-south-2b",
    "ap-south-2c"
  ]
}