module Voluntary
  module Api
    module V1
      module Things
        class ArgumentsController < ActionController::Base
          include Voluntary::V1::BaseController
         
          respond_to :json
          
          def comparison
            options = {}
          
            arguments = Argument.compare_two_argumentables(params[:argumentable_type], params[:side], params[:left_thing_name], params[:right_thing_name]).
                        paginate(page: params[:page], per_page: 10)
            
            options[:json] = arguments.map do |argument_comparison|
              hash = { 
                left: { id: argument_comparison.id, value: argument_comparison.value },
                right: { id: argument_comparison.right_id, value: argument_comparison.right_value },
                topic: { id: argument_comparison.topic_id, name: argument_comparison.topic_name }
              }
              
              if params[:side] == 'right'
                left = hash[:left].clone
                right = hash[:right].clone
                hash[:left] = right
                hash[:right] = left
              end
              
              hash
            end
            
            options[:meta] = { 
              pagination: {
                total_pages: arguments.total_pages, current_page: arguments.current_page,
                previous_page: arguments.previous_page, next_page: arguments.next_page
              }
            }
            
            respond_with do |format|
              format.json { render options }
            end
          end
        end
      end
    end
  end
end