module Voluntary
  module CollectionHelper
    def table_cell column, resource, alternative_value = nil
      value = '-'
      
      if column == 'name'
        value = resource.send(column)
        
        if alternative_value.is_a?(Proc)
          return alternative_value.call(resource)
        elsif value.blank? && alternative_value.present? 
          value = eval("resource.#{alternative_value}")
        elsif value.blank?
          value = '-'
        end
        
        begin
          link_to value, eval("#{root_model_class_name(resource).tableize.singularize}_path(resource)")
        rescue
          link_to value, eval("#{root_model_class_name(resource).constantize.table_name.singularize}_path(resource)")
        end
      elsif column.match('_id')
        association = nil
        
        begin
          association = resource.send(column.gsub('_id', '')) 
        rescue 
          association = eval("resource.#{alternative_value}") if alternative_value.present?
        end
        
        if association
          begin
            link_to(association.name, association)
          rescue NoMethodError
            link_to(association.name, resource_path(association))
          end
        else
          value
        end
      else
        resource.send(column) 
      end
    end
  end
end