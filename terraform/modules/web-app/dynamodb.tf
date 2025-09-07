# DynamoDB table to store input from web form

resource "aws_dynamodb_table" "dynamodb-table" {
  name           = "film-tracker-app-table"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5

  hash_key = "ID"

  # Columns
  attribute {
    name = "ID"
    type = "S"
  }
  # # No need to specify a schema, because NoSQL database is flexible
  # attribute {
  #   name = "Title"
  #   type = "S"
  # }
  # attribute {
  #   name = "Type"
  #   type = "S"
  # }
  # attribute {
  #   name = "Score"
  #   type = "N"
  # }
  # attribute {
  #   name = "WatchedDate"
  #   type = "S"
  # }
  # attribute {
  #   name = "ReleaseYear"
  #   type = "S"
  # }
  # attribute {
  #   name = "requestTime"
  #   type = "S"
  # }

  tags = {
    name = "film-tracker-app-table"
  }
}

# Next: State locking