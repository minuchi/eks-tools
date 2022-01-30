variable "availability_zones" {
  default     = ["ap-northeast-2a", "ap-northeast-2c"]
  type        = list(string)
  description = "AWS availablity zones"
}

variable "ip_prefix" {
  default     = "10.100"
  type        = string
  description = "AWS VPC ip prefix"
}
