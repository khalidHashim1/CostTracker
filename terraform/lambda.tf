resource "aws_lambda_function" "mylambdaFunction" {
        function_name = "costtracker"
        role          = "arn:aws:iam::665832050840:role/service-role/costtracker-role-9rsd1voi"
        handler       = "lambda_function.lambda_handler"
        runtime       = "python3.13"
        publish       = false
        
        # Placeholder to satisfy Terraform requirement
        s3_bucket = "dummy-bucket-terraform-placeholder"
        s3_key    = "dummy.zip"

        lifecycle {
            ignore_changes = [filename, s3_bucket, s3_key]
        }
}

# Lambda Premission
resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "allow-eventbridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.mylambdaFunction.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.weekly_trigger.arn
}

# EventBridge Trigger
resource "aws_cloudwatch_event_rule" "weekly_trigger" {
  name                = "weekly-trigger"
  description         = "cost tracker trigger for lambda function. "
  schedule_expression = "cron(0 0 ? * SUN *)"
}
# EventBridge Target
resource "aws_cloudwatch_event_target" "costtracker_target" {
  rule = aws_cloudwatch_event_rule.weekly_trigger.name
  arn  = aws_lambda_function.mylambdaFunction.arn
}