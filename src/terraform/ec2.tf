resource "aws_instance" "web" {

  instance_type = "t2.micro"

  # Lookup the correct AMI based on the region
  # we specified
  ami = data.aws_ami.ubuntu.id

  # Our Security group to allow HTTP and SSH access
  vpc_security_group_ids = [aws_security_group.default.id]

  # We're going to launch into the same subnet as our ELB. In a production
  # environment it's more common to have a separate private subnet for
  # backend instances.
  subnet_id = aws_subnet.default.id

  # We run a remote provisioner on the instance after creating it.
  # In this case, we just install nginx and start it. By default,
  # this should be on port 80

  key_name = "alex"

 
   provisioner "remote-exec" {

    inline = [
      "sudo apt-get -y update",
      "sudo apt-get -y install nginx",
      "sudo service nginx start",
    ]
  }

    #provisioner "local-exec" {
      #command = "sleep 5m && inspec exec https://github.com/dev-sec/nginx-baseline.git --key-files alex.pem --target ssh://ubuntu@${self.public_ip}"
    #}

    connection {
    host = aws_instance.web.public_ip
    type     = "ssh"
    user     = "ubuntu"
    password = ""
    private_key = file(var.ssh_privatekey)
  }


   tags = {
    Name = "devopsmad-ec2"
  }
}