module Prometheus
  module Metrics
    def self.preset_labels
      {
        app: Rails.application.config.x.vcap_app["application_name"],
        organisation: Rails.application.config.x.vcap_app["organization_name"],
        space: Rails.application.config.x.vcap_app["space_name"],
        app_instance: ENV["CF_INSTANCE_INDEX"],
      }
    end

    prometheus = Prometheus::Client.registry

    prometheus.counter(
      :tta_requests_total,
      docstring: "A counter of requests",
      labels: %i[path method status] + preset_labels.keys,
      preset_labels:,
    )

    prometheus.histogram(
      :tta_request_duration_ms,
      docstring: "A histogram of request durations",
      labels: %i[path method status] + preset_labels.keys,
      preset_labels:,
    )

    prometheus.histogram(
      :tta_request_view_runtime_ms,
      docstring: "A histogram of request view runtimes",
      labels: %i[path method status] + preset_labels.keys,
      preset_labels:,
    )

    prometheus.histogram(
      :tta_render_view_ms,
      docstring: "A histogram of view rendering times",
      labels: %i[identifier] + preset_labels.keys,
      preset_labels:,
    )

    prometheus.histogram(
      :tta_render_partial_ms,
      docstring: "A histogram of partial rendering times",
      labels: %i[identifier] + preset_labels.keys,
      preset_labels:,
    )

    prometheus.counter(
      :tta_cache_read_total,
      docstring: "A counter of cache reads",
      labels: %i[key hit] + preset_labels.keys,
      preset_labels:,
    )

    prometheus.counter(
      :tta_csp_violations_total,
      docstring: "A counter of CSP violations",
      labels: %i[blocked_uri document_uri violated_directive] + preset_labels.keys,
      preset_labels:,
    )

    prometheus.counter(
      :tta_feedback_visit_total,
      docstring: "A counter of feedback visit responses",
      labels: %i[successful] + preset_labels.keys,
      preset_labels:,
    )

    prometheus.counter(
      :tta_feedback_rating_total,
      docstring: "A counter of feedback rating responses",
      labels: %i[rating] + preset_labels.keys,
      preset_labels:,
    )

    prometheus.counter(
      :tta_client_cookie_consent_total,
      docstring: "A counter of cookie consent",
      labels: %i[non_functional marketing] + preset_labels.keys,
      preset_labels:,
    )
  end
end
