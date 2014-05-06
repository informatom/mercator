class JobLogger

  def self.info(message)
    @joblogger ||= Logger.new("#{Rails.root}/log/#{Rails.env}_jobs.log")
    @joblogger.info(message) unless message.nil?
  end

  def self.warn(message)
    @joblogger ||= Logger.new("#{Rails.root}/log/#{Rails.env}_jobs.log")
    @joblogger.warn(message) unless message.nil?
  end

  def self.error(message)
    @joblogger ||= Logger.new("#{Rails.root}/log/#{Rails.env}_jobs.log")
    @joblogger.error(message) unless message.nil?
  end

  def self.fatal(message)
    @joblogger ||= Logger.new("#{Rails.root}/log/#{Rails.env}_jobs.log")
    @joblogger.fatal(message) unless message.nil?
  end

  def self.debug(message)
    @joblogger ||= Logger.new("#{Rails.root}/log/#{Rails.env}_jobs.log")
    @joblogger.debug(message) unless message.nil?
  end
end