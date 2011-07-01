# config/initializers/delayed_job_config.rb
Delayed::Worker.destroy_failed_jobs = true
Delayed::Worker.max_attempts = 3
Delayed::Worker.max_run_time = 5.minutes
Delayed::Worker.delay_jobs = !Rails.env.test?

