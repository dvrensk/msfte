module Msfte #:nodoc:

  # This module defines the acts_as_msfte method and is included into 
  # ActiveRecord::Base
  module ActMethods
    def reloadable? #:nodoc:
      true
    end
    # Declares a class as searchable through the MSSQL full-text engine.
    def acts_as_msfte
      extend ClassMethods
    end
  end
end
