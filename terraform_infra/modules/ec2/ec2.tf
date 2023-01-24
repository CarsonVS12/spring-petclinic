resource "tls_private_key" "key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
# Generate a Private Key and encode it as PEM.
resource "aws_key_pair" "key_pair" {
  key_name   = "spring-petclinic-key"
  public_key = tls_private_key.key.public_key_openssh

  provisioner "local-exec" {
    command = "echo '${tls_private_key.key.private_key_pem}' > ./key.pem"
  }
}


resource "aws_instance" "ec2_web" {
  instance_type          = "t2.micro" # free instance
  ami                    = "ami-0043df2e553ad12b6"
  key_name               = aws_key_pair.key_pair.id
  vpc_security_group_ids = [aws_security_group.public_sg.id]
  subnet_id              = "subnet-009dd109297d18e2c"

  tags = {
    Name = "${var.name_prefix}"
  }


  root_block_device {
    volume_size = 10
  }
}

# Create and assosiate an Elastic IP
resource "aws_eip" "eip" {
  instance = aws_instance.ec2_web.id
}
