module Vendors
  module SimpleNavigation
    module Renderer
      class TwitterSidenav < ::SimpleNavigation::Renderer::Base
        def render(item_container)
          content, first_item_selected = '', false
            
          item_container.items.each do |item|
            next if [
              I18n.t('general.edit'), I18n.t('general.destroy'), I18n.t('general.steps')
            ].include?(item.name)
            
            selected = item.selected? && item.method.blank?
            klass = selected && !first_item_selected ? 'active' : ''
            options = {}
            
            # only highlight on item
            first_item_selected = true if selected
            
            if item.method.present?
              options.merge!(method: item.method, confirm: I18n.t('general.questions.are_you_sure'))
            end
            
            content += link_to(item.name, item.url, options.merge({ class: "list-group-item #{klass}"}))
          end
      
          content_tag :div, content_tag(:div, content, class: 'list-group'), class: 'well sidebar-nav'
        end
      end
    end
  end
end