module Applicat
  module Mvc
    module Model
      module Resource
        module Base
          def self.included(base)
            base.class_eval do
              cattr_reader :per_page
              @@per_page = 20
  
              attr_accessor :current_user
                
              if self.table_exists?
                
                columns.map(&:name).select{|c| c.match('_id')}.each do |column|
                  association = column.split('_id').first.classify
                  
                  define_method "#{association.underscore}_name" do
                    self.send("#{association.underscore}").try(:name)
                  end
                  
                  accessible_attributes << "#{association.underscore}_name"
                  
                  define_method "#{association.underscore}_name=" do |name|
                    return if name.blank?
                    
                    association_type = association
                    
                    if self.class.columns.map(&:name).include?("#{association.underscore}_type")
                      association_type = self.send("#{association.underscore}_type")
                    end
                    
                    begin
                      association_type = association_type.constantize
                    rescue
                      association_type = self.class.reflections[column.split('_id').first.to_sym].options[:class_name].constantize
                    end
                     
                    self.send("#{association.underscore}=", association_type.find_or_initialize_by_name(name))
                  end
                end
              end
              
              def to_s
                self.name rescue self.class.name.humanize
              end
            end
          end
        end
      end
    end
  end
end