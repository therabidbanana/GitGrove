# config/initializers/delayed_job_config.rb
Delayed::Worker.destroy_failed_jobs = false
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
      Delayed::Job.enqueue(SiteArchiveJob.new(site.id))
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

class SiteArchiveJob < Struct.new(:site_id)
  def perform
    site = Site.find_by_id(site_id)
    Dir.chdir(site.preview_path) do
      system "cd output; zip -r #{site.url} *"
      system "mv output/#{site.url}.zip #{Yetting.archives_path}/"
    end if site && Yetting.archives_path
  end

  def before(job)
  end

  def success(job)
  end

  def error(job, my_exception)
  end

  def failure
  end
end

