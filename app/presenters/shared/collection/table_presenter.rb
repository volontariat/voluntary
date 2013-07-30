class Shared::Collection::TablePresenter < Presenter
  def initialize(subject, options = {})
    super(subject, options)
    
    set_default_options(
      {  
        current_parent: parent, show_title: true, append_new_link: true, show_actions: true
      }
    )
  end
  
  def set_options(options)
    @options.merge!(options)
  end
  
  def actions
    return '' unless show_actions
    
    content_tag :td, render('shared/resource/actions', type: type, resource: resource)
  end
  
  def new_link(options = {})
    return '' unless append_new_link
    
    path = if current_parent
      send(
        "new_#{root_model_class_name(current_parent).tableize.singularize}_#{type.gsub('.', '_').singularize}_path(current_parent)", 
        options
      )
    else
      send("new_#{type.gsub('.', '_').singularize}_path", options)
    end
    
    link_to t("#{type}.new.title"), path
  end
end