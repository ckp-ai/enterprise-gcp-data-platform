resource "google_pubsub_topic" "main" {
  name    = var.topic_name
  project = var.project_id
  labels  = var.labels
}
resource "google_pubsub_topic" "dlq" {
  name    = "${var.topic_name}-dlq"
  project = var.project_id
  labels  = merge(var.labels, { purpose = "dead_letter" })
}
resource "google_pubsub_subscription" "sub" {
  name    = var.subscription_name
  topic   = google_pubsub_topic.main.id
  project = var.project_id
  ack_deadline_seconds = 60
  dead_letter_policy { dead_letter_topic = google_pubsub_topic.dlq.id max_delivery_attempts = 5 }
  retry_policy { minimum_backoff = "10s" maximum_backoff = "600s" }
}
