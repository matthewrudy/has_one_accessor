require File.dirname(__FILE__) + "/lib/has_one_accessor"
require 'active_record'
ActiveRecord::Base.extend HasOneAccessor::ActsMethods
