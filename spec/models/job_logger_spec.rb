require 'spec_helper'

RSpec.describe JobLogger, :type => :model do


# ---CLass Methods  --- #

  context "info" do
    it "creates an info log entry" do
      expect{JobLogger.info("info")}.to change{Logentry.count}.by(1)
    end
  end

  context "warn" do
    it "creates an warn log entry" do
      expect{JobLogger.warn("warn")}.to change{Logentry.count}.by(1)
    end
  end

  context "error" do
    it "creates an error log entry" do
      expect{JobLogger.error("error")}.to change{Logentry.count}.by(1)
    end
  end

  context "fatal" do
    it "creates an fatal log entry" do
      expect{JobLogger.fatal("fatal")}.to change{Logentry.count}.by(1)
    end
  end

  context "debug" do
    it "creates an debug log entry" do
      expect{JobLogger.debug("debug")}.to change{Logentry.count}.by(1)
    end
  end
end