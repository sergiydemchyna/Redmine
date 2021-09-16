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
resource "local_file" "load_balancer_config" {
    content = templatefile("nginx.sh", {
        REDMINE_SERVER1 = aws_instance.redmine1.private_ip,
        REDMINE_SERVER2 = aws_instance.redmine2.private_ip
    })
    filename = "nginx.sh"
}