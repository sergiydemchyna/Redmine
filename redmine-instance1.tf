# Redmine1
resource "aws_instance" "redmine1" {
    ami = var.ami
    instance_type = var.instance_typ
    depends_on = [aws_instance.maria_db]
    tags = {
        Name = "Redmine1"
    }
    # VPC
    subnet_id = "${aws_subnet.prod-subnet-public-1.id}"
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
resource "local_file" "redmine_config" {
    content = templatefile("redmine.sh", {
        MARIA_DB_SERVER = aws_instance.maria_db.private_ip,
    })
    filename = "redmine.sh"
}