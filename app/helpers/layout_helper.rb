module LayoutHelper
  def breadcrumbs
    result = render_navigation context: :main, renderer: :breadcrumbs_without_method_links, join_with: ' &gt; '
    result && result.split('<a').length > 2 ? result : ''
    
    if respond_to?(:resource) && resource.respond_to?(:ancestors)
      breadcrumbs_with_ancestors(result)
    else
      result
    end
  end
  
  def breadcrumbs_with_ancestors(links)
    links = links.split(' &gt; ')
    current_resource_link = links.pop
    links += resource.ancestors.map {|ancestor| link_to ancestor.name, ancestor }
    links << current_resource_link
    raw links.join(' &gt; ')    
  end
  
  def sidenav
    result = render_navigation context: :main, renderer: :twitter_sidenav, level: @twitter_sidenav_level
    result && result.split('<a').length > 2 ? result : ''
  end
  
  def footer_navigation
    links = []
    
    ['privacy-policy', 'terms-of-use', 'about-us'].each do |page_name|
      text = t("pages.#{page_name.gsub('-', '_')}.title")
      path = "#{controller_name}/#{params[:id]}"
      active = path == "#{controller_name}/#{page_name}"
      links << (active ? text : link_to(text, page_path(page_name)))
    end
    
    raw links.join(' | ')
  end
end