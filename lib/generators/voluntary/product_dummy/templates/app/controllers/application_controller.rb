class ApplicationController < Voluntary::ApplicationController
  layout Proc.new { |controller| controller.request.xhr? ? 'facebox' : 'application' }
end