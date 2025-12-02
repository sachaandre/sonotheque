# Configure AWS SDK for Cloudflare R2 compatibility
require 'aws-sdk-s3'

Aws.config.update(
  http_wire_trace: false,
  compute_checksums: false
)
