resource "aws_budgets_budget" "this" {
  name         = "${var.name_prefix}-monthly-budget"
  budget_type  = "COST"
  limit_amount = tostring(var.monthly_budget_usd)
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  # Only counts spend tagged <tag_key>=<tag_value>.
  # The tag must be activated as a cost-allocation tag first (see README).
  cost_filter {
    name   = "TagKeyValue"
    values = [format("user:%s$%s", var.tag_key, var.tag_value)]
  }

  dynamic "notification" {
    for_each = var.notification_thresholds
    content {
      comparison_operator        = "GREATER_THAN"
      threshold                  = notification.value
      threshold_type             = "PERCENTAGE"
      notification_type          = "ACTUAL"
      subscriber_email_addresses = [var.alert_email]
    }
  }
}
