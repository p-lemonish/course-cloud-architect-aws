resource "aws_s3_bucket" "public_storage" {
  bucket = "chatroom-public-storage"
  tags = merge(local.common_tags, {
    Name = "chatroom-public-storage",
    Type = "Public"
  })
}

resource "aws_s3_bucket" "protected_storage" {
  bucket = "chatroom-protected-storage"
  tags = merge(local.common_tags, {
    Name = "chatroom-protected-storage",
    Type = "Protected"
  })
}

resource "aws_s3_bucket_public_access_block" "public_storage" {
  bucket = aws_s3_bucket.public_storage.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "public_storage" {
  bucket     = aws_s3_bucket.public_storage.id
  depends_on = [aws_s3_bucket_public_access_block.public_storage]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.public_storage.arn}/*"
      }
    ]
  })
}
