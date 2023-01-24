resource "aws_ecr_repository" "main" {
  name                 = "${var.name_prefix}-image"
  image_tag_mutability = "MUTABLE"
}