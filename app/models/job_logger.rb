class JobLogger

  def self.info(message)
    Logentry.create(severity: :info, message: message)
  end

  def self.warn(message)
    Logentry.create(severity: :warn, message: message)
  end

  def self.error(message)
    Logentry.create(severity: :error, message: message)
  end

  def self.fatal(message)
    Logentry.create(severity: :fatal, message: message)
  end

  def self.debug(message)
    Logentry.create(severity: :debug, message: message)
  end
end