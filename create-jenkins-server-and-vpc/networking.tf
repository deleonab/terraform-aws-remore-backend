// Create VPC
resource "aws_vpc" "devops_uncut_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${var.environ}-devops_uncut_vpc"
    
  }
}

# Create 2 public subnets

resource "aws_subnet" "public_subnet1" {
  vpc_id     = aws_vpc.devops_uncut_vpc.id 
  cidr_block = var.public_subnet1_cidr
  availability_zone = var.az1
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.environ}-public_subnet1"
    
  }
}

resource "aws_subnet" "public_subnet2" {
  vpc_id     = aws_vpc.devops_uncut_vpc.id 
  cidr_block = var.public_subnet2_cidr
  availability_zone = var.az2
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.environ}-public_subnet2"
    "kubernetes.io/cluster/my-eks-cluster" = "shared"
    "kubernetes.io/role/internal-elb"         = 1
  }
}


// Create Internet Gateway

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.devops_uncut_vpc.id

  tags = {
    Name = "${var.environ}-igw"
  }
}

resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.devops_uncut_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.environ}-public-rt"
  }
}

resource "aws_route_table_association" "public_rt_association1" {
    subnet_id = aws_subnet.public_subnet1.id
    route_table_id = aws_route_table.public-rt.id
  
}

resource "aws_route_table_association" "public_rt_association2" {
    subnet_id = aws_subnet.public_subnet2.id
    route_table_id = aws_route_table.public-rt.id
  
}


/*

module "sgs" {
    source = "./eks-sg"
    vpc_id = aws_vpc.devops_uncut_vpc.id 
}

module "eks" {
  source = "./eks"
  vpc_id = aws_vpc.devops_uncut_vpc.id
  subnet_ids = [aws_subnet.public_subnet1.id, aws_subnet.public_subnet2.id]
  sg_ids = module.sgs.security_group_public
}
*/
##############################################################################
#------------------------------------------------------------------------------
#------------------------------------------------------------------------------

