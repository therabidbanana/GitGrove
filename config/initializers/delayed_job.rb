# config/initializers/delayed_job_config.rb
Delayed::Worker.destroy_failed_jobs = true
Delayed::Worker.max_attempts = 3
Delayed::Worker.max_run_time = 5.minutes
#Delayed::Worker.delay_jobs = !Rails.env.test?


class SiteBuildJob < Struct.new(:site_id)
  def perform
    site = Site.find_by_id(site_id)
    site.preview_repo_setup
    Dir.chdir(site.preview_path) do
      system "git pull &> /dev/null"
      puts "   (Rebuilding #{site.preview_path} with nanoc)"
      system "nanoc3 co &> /dev/null"
    end if site
  end

  def before(job)
    site = Site.find_by_id(site_id)
    site.dequeue if site
  end

  def success(job)
    site = Site.find_by_id(site_id)
    site.finish if site
  end

  def error(job, my_exception)
    site = Site.find_by_id(site_id)
    site.exception if site
  end

  def failure
    site = Site.find_by_id(site_id)
    site.exception if site
  end
end

