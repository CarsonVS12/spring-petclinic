resource "aws_cloudwatch_metric_alarm" "alb_unhealthyhosts" {
  alarm_name          = "${var.name_prefix}-alb-unhealthy-hosts"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "3"
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = "60"
  statistic           = "Average"
  threshold           = "0"

  dimensions = {
    TargetGroup  = aws_alb_target_group.main.arn_suffix
    LoadBalancer = aws_lb.main.arn_suffix
  }

  alarm_description = "This metric monitor the existence of any unhealthy hosts"
  actions_enabled   = "true"
  alarm_actions     = [aws_sns_topic.alb_unhealthyhosts.arn]
  ok_actions        = [aws_sns_topic.alb_healthyhosts.arn]
}

resource "aws_sns_topic" "alb_unhealthyhosts" {
  name         = "${var.name_prefix}-alb-unhealthy-hosts"
  display_name = "ALARM ON: ${var.name_prefix}-alb-unhealthy-hosts"
}

resource "aws_sns_topic_subscription" "alb_unhealthyhosts" {
  topic_arn = aws_sns_topic.alb_unhealthyhosts.arn
  protocol  = "email"
  endpoint  = var.alb_alarm_email_address
}

resource "aws_sns_topic" "alb_healthyhosts" {
  name         = "${var.name_prefix}-alb-healthy-hosts"
  display_name = "ALARM OFF: ${var.name_prefix}-alb-unhealthy-hosts"
}

resource "aws_sns_topic_subscription" "alb_healthyhosts" {
  topic_arn = aws_sns_topic.alb_healthyhosts.arn
  protocol  = "email"
  endpoint  = var.alb_alarm_email_address
}