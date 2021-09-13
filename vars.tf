

variable "region" {
    default = "eu-west-3"
}

variable "ami" {
    default = "ami-0f7cd40eac2214b37"
}
variable "instance_typ" {
    default = "t2.micro"
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