# frozen_string_literal: true

threads_count = ENV.fetch('RAILS_MAX_THREADS') { 5 }
threads threads_count, threads_count

port        ENV.fetch('PORT') { 3000 }

# Specifies the `environment` that Puma will run in.
environment ENV.fetch('RAILS_ENV') { 'development' }

# Allow puma to be restarted by `rails restart` command.
plugin :tmp_restart
