module Voluntary
  module ApplicationHelper
    include AutoHtml
    
    def self.root_model_class_name_helper(resource)
      if resource.class.superclass.name == 'ActiveRecord::Base'
        resource.class.name
      elsif resource.class.superclass.name == 'Object'
        # classes like mongo db models without a specific superclass
        resource.class.name
      else
        resource.class.superclass.name
      end
    end
    
    def markdown(text)
      text = Redcarpet::Markdown.new(Redcarpet::Render::XHTML.new(filter_html: true)).render(text)
      
      auto_html(text) do 
        youtube(width: 515, height: 300)
        dailymotion(width: 515, height: 300)
        vimeo(width: 515, height: 300)
        google_video(width: 515, height: 300)
        image
  
        redcarpet(
          renderer: Redcarpet::Render::XHTML.new(
            no_images: true, no_styles: true, hard_wrap: true, with_toc_data: true
          ),
          markdown_options: { no_intra_emphasis: true, autolink: true, fenced_code_blocks: true }
        )
        link :target => "_blank", :rel => "nofollow"
      end.gsub(/(>https?:\/\/[^\<\\]+)/) do |match| 
        truncate(match)
      end.html_safe
    end
    
    def root_model_class_name(resource)
      ::Voluntary::ApplicationHelper.root_model_class_name_helper(resource)
    end
    
    def directory_for_resource(resource)
      resource.class.name.split('::').last.underscore
    end
    
    def link_list(collection)
      raw collection.map{|a| link_to a.name, a}.join(', ')
    end
    
    def general_attribute?(attribute)
      begin
        I18n.t("attributes.#{attribute}", raise: true)
        true
      rescue
        false
      end
    end
    
    def attribute_translation(attribute, current_resource = nil)
      current_resource = current_resource || resource
      t("activerecord.attributes.#{root_model_class_name(current_resource).underscore}.#{attribute}",
        default: t("attributes.#{attribute}")
      )
    end
    
    def polymorphic_or_resource_path(record)
      begin 
        polymorphic_path(record) 
      rescue NoMethodError
        resource_path(record)
      end
    end
    
    def resource_path(record)
      klass = ::Voluntary::ApplicationHelper.root_model_class_name_helper(record)
      eval("#{klass.tableize.singularize}_path(record)")
    end
    
    def name_with_apostrophe(value)
      value =~ /s$/i ? "#{value}'" : "#{value}'s"
    end
    
    def event_links_for_resource(current_resource, type)
      return [] unless current_resource.respond_to? :state_events
      
      links = []
      
      current_resource.state_events.select{|event| can? event, current_resource }.each do |event|
        path = "#{event}_#{type.singularize}_path"
        
        next unless respond_to? path
        
        path = eval("#{path}(current_resource)")
        links << link_to(t("#{type}.show.events.#{event}"), path, method: :put)
      end
      
      links
    end
  end
end