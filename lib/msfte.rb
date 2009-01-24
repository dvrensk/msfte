# Msfte

require 'msfte/act_methods'
require 'msfte/class_methods'

# include acts_as_msfte method into ActiveRecord::Base
ActiveRecord::Base.extend Msfte::ActMethods

# Rails adds :readonly to the find options when it doesn't recognise the columns
# used (i.e., when Msfte adds CONTAINSTABLEs), but AR.count explodes if it sees
# :readonly.
returning ActiveRecord::Calculations::CALCULATIONS_OPTIONS do |options|
  options.push :readonly unless options.include?(:readonly)
end

module Msfte
  @@logger = Logger.new "#{RAILS_ROOT}/log/msfte.log"
  @@logger.level = ActiveRecord::Base.logger.level rescue Logger::DEBUG
  mattr_accessor :logger
end