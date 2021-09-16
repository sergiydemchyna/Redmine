# MariaDB
resource "aws_instance" "maria_db" {
    ami = var.ami
    instance_type = var.instance_typ
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

