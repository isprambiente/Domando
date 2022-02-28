class CacheFreeLogger < ActiveSupport::Logger
  def add(severity, message = nil, progname = nil, &block)
    return true if progname&.include? "CACHE"
    super
  end
end

ActiveRecord::Base.logger = CacheFreeLogger.new(STDOUT) if Rails.env.development?
