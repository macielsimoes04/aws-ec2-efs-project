resource "aws_instance" "main_ec2" {
    ami = "ami-02dfbd4ff395f2a1b"
    instance_type = "t3.micro"
    subnet_id = aws_subnet.Public_main.id
    associate_public_ip_address = true
    vpc_security_group_ids = [aws_security_group.web_sg.id]
  
    user_data = <<-EOT
        #!/bin/bash
        dnf update -y
        dnf install -y httpd
        systemctl start httpd
        systemctl enable httpd
        echo '<h1>Hello World!</h1>' > /var/www/html/index.html
    EOT

    tags = {
        Name = "SimpleWebServer"
    }
}