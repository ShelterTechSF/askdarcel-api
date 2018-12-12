# frozen_string_literal: true

# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment', __FILE__)

require_relative 'config/environment'
require 'prometheus/middleware/collector'
require 'prometheus/middleware/exporter'

# require 'dotenv/rails-now'

use Prometheus::Middleware::Collector
use Prometheus::Middleware::Exporter

run Rails.application
