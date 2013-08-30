module FormHelper
  def link_to_add_fields(name, f, association, options = {})
    attributes = { 
      "#{root_model_class_name(f.object).tableize.singularize}".to_sym => f.object 
    }
    
    new_object = if f.object.respond_to? "#{association.to_s.singularize}_class"
      f.object.send("#{association.to_s.singularize}_class").new(attributes) 
    else
      f.object.send(association).new(attributes)
    end
    
    id = new_object.object_id

    #fields = f.fields_for(association, new_object, child_index: id) do |builder|
    fields = f.simple_fields_for(association) do |builder|
      render_product_specific_partial_if_available(
        new_object, "#{controller_name}/#{association.to_s.singularize}_fields",
        f: builder
      )
    end
    
    data = {id: id, fields: fields.gsub("\n", '')}
    data[:target] = options[:target] if options.has_key?(:target)
        
    link_to(name, '#', class: 'add_fields', data: data)
  end
  
  def remove_fields(f)
    if f.object.try(:new_record?)
      link_to t('general.remove'), '#', class: 'remove_fields'
    else
      f.check_box(:_destroy) + f.label(:_destroy, t('general.destroy'))
    end
  end
    
  def autocomplete_input(f, field, namespace = nil)
    if namespace
      f.input "#{field}_name", input_html: { data: {autocomplete: eval("autocomplete_#{namespace}_#{field.to_s.tableize}_path")} }
    else
      f.input "#{field}_name", input_html: { data: {autocomplete: eval("autocomplete_#{field.to_s.tableize}_path")} }
    end
  end
end