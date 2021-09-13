provider "aws" {
    region = var.region
    access_key = var.access_key
    secret_key = var.secret_key
}
# MariaDB
resource "aws_instance" "maria_db" {
    ami = var.ami
    instance_type = var.instance_typ
    private_ip = "10.0.1.31"
    tags = {
        Name = "Maria DB"
    }
    # VPC
    subnet_id = "${aws_subnet.prod-subnet-public-1.id}"
    # Security Group
    vpc_security_group_ids = [
        "${aws_security_group.allowed.id}"]
    # the Public SSH key
    key_name = "${aws_key_pair.deployer.id}"
    # Maria DB installation


    provisioner "file" {
        source = "mariadb.sh"
        destination = "mariadb.sh"
    }
    provisioner "remote-exec" {
        inline = [
            "chmod +x mariadb.sh",
             "sudo ./mariadb.sh"
        ]
    }
    connection {
        type        = "ssh"
        user        = "ubuntu"
        host        = self.public_ip
        private_key = file(var.private_key)
    }
}
# Redmine1
resource "aws_instance" "redmine1" {
    ami = var.ami
    instance_type = var.instance_typ
    private_ip = "10.0.1.32"
    depends_on = [aws_instance.maria_db]
    tags = {
        Name = "Redmine1"
    }
    # VPC
    subnet_id = "${aws_subnet.prod-subnet-privat-1.id}"
    # Security Group
    vpc_security_group_ids = [
        "${aws_security_group.allowed.id}"]
    # the Public SSH key
    key_name = "${aws_key_pair.deployer.id}"
    # Redmine1 installation
    provisioner "file" {
        source = "redmine.sh"
        destination = "redmine.sh"
    }
    provisioner "remote-exec" {
        inline = [
            "chmod +x redmine.sh",
            "sudo ./redmine.sh"
        ]
    }
    connection {
        type        = "ssh"
        user        = "ubuntu"
        host        = self.public_ip
        private_key = file(var.private_key)
    }
}

# Redmine2
resource "aws_instance" "redmine2" {
    ami = var.ami
    instance_type = var.instance_typ
    private_ip = "10.0.1.33"
    depends_on = [aws_instance.redmine1]
    tags = {
        Name = "Redmine2"
    }
    # VPC
    subnet_id = "${aws_subnet.prod-subnet-privat-2.id}"
    # Security Group
    vpc_security_group_ids = [
        "${aws_security_group.allowed.id}"]
    # the Public SSH key
    key_name = "${aws_key_pair.deployer.id}"
    # Redmine2 installation
    provisioner "file" {
        source = "redmine.sh"
        destination = "redmine.sh"
    }
    provisioner "remote-exec" {
        inline = [
            "chmod +x redmine.sh",
            "sudo ./redmine.sh"
        ]
    }
    connection {
        type        = "ssh"
        user        = "ubuntu"
        host        = self.public_ip
        private_key = file(var.private_key)
    }
}
# NGINX LB
resource "aws_instance" "nginx" {
    ami = var.ami
    instance_type = var.instance_typ
    depends_on = [aws_instance.redmine2]
    tags = {
        Name = "Nginx LB"
    }
    # VPC
    subnet_id = "${aws_subnet.prod-subnet-public-1.id}"
    # Security Group
    vpc_security_group_ids = [
        "${aws_security_group.allowed.id}"]
    # the Public SSH key
    key_name = "${aws_key_pair.deployer.id}"
    # NGINX installation
    provisioner "file" {
        source = "nginx.sh"
        destination = "nginx.sh"
    }
    provisioner "remote-exec" {
        inline = [
            "chmod +x nginx.sh",
            "sudo ./nginx.sh"
        ]
    }
    connection {
        type        = "ssh"
        user        = "ubuntu"
        host        = self.public_ip
        private_key = file(var.private_key)
    }
}
resource "aws_key_pair" "deployer" {
    key_name   = "key2"
    public_key = file(var.public_key)
}
