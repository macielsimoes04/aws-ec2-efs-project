resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
    tags =  {
        Name = "main"
    }
}

resource "aws_internet_gateway" "gw_vpc_main"{
    vpc_id = aws_vpc.main.id

    tags = {
        Name = "gw_vpc_main"
    }
}

resource "aws_subnet" "Public_main" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"

    tags = {
        Name = "Public-main"
    }
}

resource "aws_route_table" "public_main_rt" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gw_vpc_main.id
    }

    tags = {
        Name = "public-main-rt"
    }
}

resource "aws_route_table_association" "public_main_asso" {
    subnet_id = aws_subnet.Public_main.id
    route_table_id = aws_route_table.public_main_rt.id
}

resource "aws_security_group" "web_sg" {
    vpc_id = aws_vpc.main.id
    name = "web-sg"
    description = "Allow inbound HTTP (80) and HTTPS (443) traffic"

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "web-sg"
    }
}
