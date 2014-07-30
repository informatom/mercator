class JobLogger

  def self.info(message)
    @joblogger ||= Logger.new("#{Rails.root}/log/#{Rails.env}_jobs.log")
    @joblogger.ap(message, :info) unless message.nil?
  end

  def self.warn(message)
    @joblogger ||= Logger.new("#{Rails.root}/log/#{Rails.env}_jobs.log")
    @joblogger.ap(message, :warn) unless message.nil?
  end

  def self.error(message)
    @joblogger ||= Logger.new("#{Rails.root}/log/#{Rails.env}_jobs.log")
    @joblogger.ap(message, :error) unless message.nil?
  end

  def self.fatal(message)
    @joblogger ||= Logger.new("#{Rails.root}/log/#{Rails.env}_jobs.log")
    @joblogger.ap(message, :fatal) unless message.nil?
  end

  def self.debug(message)
    @joblogger ||= Logger.new("#{Rails.root}/log/#{Rails.env}_jobs.log")
    @joblogger.ap(message, :debug) unless message.nil?
  end
end