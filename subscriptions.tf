locals {
  subscriptions_map = { for subscription in var.subscriptions : subscription.name => subscription }
}

module "subscription" {
  source = "github.com/mineiros-io/terraform-google-pubsub-subscription?ref=v0.1.0"

  for_each = var.module_enabled ? local.subscriptions_map : tomap({})

  project = google_pubsub_topic.topic[0].project
  topic   = google_pubsub_topic.topic[0].id
  name    = each.value.name

  labels                     = try(each.value.labels, {})
  ack_deadline_seconds       = try(each.value.ack_deadline_seconds, null)
  message_retention_duration = try(each.value.message_retention_duration, "604800s")
  retain_acked_messages      = try(each.value.retain_acked_messages, null)
  filter                     = try(each.value.filter, null)
  enable_message_ordering    = try(each.value.enable_message_ordering, null)

  expiration_policy_ttl = try(each.value.expiration_policy_ttl, "")
  dead_letter_policy    = try(each.value.dead_letter_policy, null)
  retry_policy          = try(each.value.retry_policy, null)
  push_config           = try(each.value.push_config, null)
  bigquery_config       = try(each.value.bigquery_config, null)

  iam = try(each.value.iam, [])

  depends_on = [var.module_depends_on]
}
