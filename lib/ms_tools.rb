require 'action_view'
require 'sanitize'
require 'nokogiri'
require 'ms_tools/engine' if defined?(Rails) && Rails::VERSION::MAJOR == 3
require 'ms_tools/application_helpers'
require 'ms_tools/head_helpers'
require 'ms_tools/sanitize'
module MsTools
end
