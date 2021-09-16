

variable "region" {
    default = "eu-west-3"
}

variable "ami" {
    default = "ami-0f7cd40eac2214b37"
}
variable "instance_typ" {
    default = "t2.micro"
}
variable "user_name" {
    default = "ubuntu"
}

variable "public_key" {
    type        = string
    description = "File path of public key."
    default     = "public.key"
}

variable "private_key" {
    type        = string
    description = "File path of private key."
    default     = "privat.key"
}
variable "vpc_net" {
    default = "10.0.0.0/23"
}


variable "az_list" {
    type = list(string)
    default = [
        "eu-west-3a",
        "eu-west-3b",
        "eu-west-3c",
    ]
}