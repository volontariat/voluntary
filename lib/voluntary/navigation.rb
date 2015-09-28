module Voluntary
  module Navigation
    class Base
      @@products = {}
      @@core_menus = [:areas, :products, :organizations, :projects, :users, :workflow, :authentication]
      @@core_menu_codes = {}
      @@menu_options = {}
      
      def self.add_product(slug, text)
        @@products[slug] = text
      end
      
      def self.products
        @@products
      end
      
      def self.core_menus
        @@core_menus.uniq
      end
      
      def self.core_menu_codes
        @@core_menu_codes
      end
      
      def self.insert_before_core_menu_item(menu, other_menu)
        @@core_menus.insert(@@core_menus.index(other_menu), menu)
      end
      
      def self.add_core_menu_code(resource, code)
        @@core_menu_codes[resource] = code
      end
      
      def self.add_menu_option(resource, option, value)
        @@menu_options[resource] ||= {}
        @@menu_options[resource][option] = value
      end
      
      def self.menu_options(resource)
        @@menu_options[resource] ||= {}
        @@menu_options[resource]
      end
    end
    
    def self.code
      Proc.new do |navigation|
        navigation.items do |primary, options|
          primary.dom_class = 'nav'
          primary.item :root, I18n.t('general.index.title'), root_path
          
          ::Voluntary::Navigation::Base.core_menus.each do |resource|
            instance_exec primary, ::Voluntary::Navigation::Base.menu_options(resource), &::Voluntary::Navigation.menu_code(resource)
          end
        end
      end
    end
    
    def self.menu_code(resource)
      case resource
      when :areas
        Proc.new do |primary, options|
          primary.item :areas, I18n.t('areas.index.title'), areas_path do |areas|
            areas.item :new, I18n.t('general.new'), new_area_path
            
            unless (@area.new_record? rescue true)
              areas.item :show, @area.name, area_path(@area) do |area|
                if can? :destroy, @area
                  area.item :destroy, I18n.t('general.destroy'), area_path(@area), method: :delete, confirm: I18n.t('general.questions.are_you_sure')
                end
                
                area.item :show, I18n.t('general.details'), "#{area_path(@area)}#top"
                area.item :edit, I18n.t('general.edit'), edit_area_path(@area) if can? :edit, @area
                area.item :users, I18n.t('users.index.title'), area_users_path(@area)
                area.item :projects, I18n.t('projects.index.title'), area_projects_path(@area)  
                
                if options[:after_resource_has_many]
                  instance_exec area, {}, &options[:after_resource_has_many]
                end
              end
            end
          end
        end
      when :products 
        Proc.new do |primary, options|
          primary.item :products, I18n.t('products.index.title'), products_path do |products|
            products.item :new, I18n.t('general.new'), new_product_path
            
            unless (@product.new_record? rescue true)
              products.item :show, @product.name, product_path(@product) do |product|
                if can? :edit, @product
                  product.item :destroy, I18n.t('general.destroy'), product_path(@product), method: :delete, confirm: I18n.t('general.questions.are_you_sure')
                end
                
                product.item :show, I18n.t('general.details'), "#{product_path(@product)}#top"
                product.item :edit, I18n.t('general.edit'), edit_product_path(@product)  if can? :edit, @product
                  
                product.item :projects, I18n.t('projects.index.title'), product_projects_path(@product)   
                
                if options[:after_resource_has_many]
                  instance_exec product, {}, &options[:after_resource_has_many]
                end
              end
            end
          end
        end
      when :organizations
        Proc.new do |primary, options|
          primary.item :organizations, I18n.t('organizations.index.title'), organizations_path do |organizations|
            organizations.item :new, I18n.t('general.new'), new_organization_path
            
            unless (@organization.new_record? rescue true)
              organizations.item :show, @organization.name, organization_path(@organization) do |organization|
                if can? :destroy, @organization
                  organization.item :destroy, I18n.t('general.destroy'), organization_path(@organization), method: :delete, confirm: I18n.t('general.questions.are_you_sure')
                end
                
                organization.item :show, I18n.t('general.details'), "#{organization_path(@organization)}#top"
                organization.item :edit, I18n.t('general.edit'), edit_organization_path(@organization) if can? :edit, @organization
                organization.item :projects, I18n.t('projects.index.title'), organization_projects_path(@organization)  
                
                if options[:after_resource_has_many]
                  instance_exec organization, {}, &options[:after_resource_has_many]
                end
              end
            end
          end
        end
      when :projects
        Proc.new do |primary, options|
          primary.item :projects, I18n.t('projects.index.title'), projects_path do |projects|
            projects.item :new, I18n.t('general.new'), new_project_path
            
            unless (@project.new_record? rescue true)
              projects.item :show, @project.name, project_path(@project) do |project|
                if can? :destroy, @project
                  project.item :destroy, I18n.t('general.destroy'), project_path(@project), method: :delete, confirm: I18n.t('general.questions.are_you_sure')
                end
                
                project.item :show, I18n.t('general.details'), "#{project_path(@project)}#top"
                project.item :edit, I18n.t('general.edit'), edit_project_path(@project) if can? :edit, @project
                
                project.item :users, I18n.t('users.index.title'), project_users_path(@project)  
                
                project.item :stories, I18n.t('stories.index.title'), project_stories_path(@project) do |stories|
                  stories.item :new, I18n.t('general.new'), new_project_story_path(@project)
      
                  unless (@story.new_record? rescue true)
                    stories.item(:show, @story.name, story_path(@story)) do |story|
                      if can? :destroy, @story
                        story.item :destroy, I18n.t('general.destroy'), story_path(@story), method: :delete, confirm: I18n.t('general.questions.are_you_sure')
                      end
                      
                      story.item :show, I18n.t('general.details'), "#{story_path(@story)}#top"
                      story.item :edit, I18n.t('general.edit'), edit_story_path(@story) if can? :edit, @story
      
                      story.item :steps, I18n.t('general.steps'), setup_tasks_story_path(@story) do |steps|
                        steps.item :setup_tasks, I18n.t('stories.steps.setup_tasks.title'), setup_tasks_story_path(@story)
                        steps.item :activate, I18n.t('general.events.activate'), activate_story_path(@story)
                      end
                                      
                      story.item :tasks, I18n.t('tasks.index.title'), story_tasks_path(@story) do |tasks|
                        tasks.item :new, I18n.t('general.new'), new_story_task_path(@story)
            
                        unless (@task.new_record? rescue true)
                          tasks.item(:show, @task.name, task_path(@task)) do |task|
                            if can? :destroy, @task
                              task.item :destroy, I18n.t('general.destroy'), task_path(@task), method: :delete, confirm: I18n.t('general.questions.are_you_sure')
                            end
                            
                            task.item :show, I18n.t('general.details'), "#{task_path(@task)}#top"
                            task.item :edit, I18n.t('general.edit'), edit_task_path(@task) if can? :edit, @task
                            
                            task.item :results, I18n.t('results.index.title'), task_results_path(@task) do |results|
                              results.item :new, I18n.t('general.new'), new_task_result_path(@task)
                  
                              unless (@result.new_record? rescue true)
                                results.item(:show, @result.name, result_path(@result)) do |result|
                                  if can? :destroy, @result
                                    result.item :destroy, I18n.t('general.destroy'), result_path(@result), method: :delete, confirm: I18n.t('general.questions.are_you_sure')
                                  end
                                  
                                  result.item :show, I18n.t('general.details'), "#{result_path(@result)}#top"
                                  result.item :edit, I18n.t('general.edit'), edit_result_path(@result) if can? :edit, @result
                                  
                                  result.item :comments, I18n.t('comments.index.title'), "#{story_path(@story)}#comments" do |comments|
                                    comments.item(:new, I18n.t('general.new'), new_story_comment_path(@story)) if @comment
                                    
                                    if can? :edit, @comment
                                      comments.item(:edit, I18n.t('general.edit'), edit_comment_path(@comment)) if @comment.try(:id)
                                    end
                                  end 
                                end
                              end
                            end
                            
                            task.item :comments, I18n.t('comments.index.title'), "#{story_path(@story)}#comments" do |comments|
                              comments.item(:new, I18n.t('general.new'), new_story_comment_path(@story)) if @comment
                              
                              if @comment.try(:id) && can?(:edit, @comment)
                                comments.item(:edit, I18n.t('general.edit'), edit_comment_path(@comment))
                              end
                            end 
                          end
                        end
                      end
                      
                      story.item :comments, I18n.t('comments.index.title'), "#{story_path(@story)}#comments" do |comments|
                        comments.item(:new, I18n.t('general.new'), new_story_comment_path(@story)) if @comment
                        
                        if @comment.try(:id) && can?(:edit, @comment)
                          comments.item(:edit, I18n.t('general.edit'), edit_comment_path(@comment))
                        end
                      end 
                      
                      if options[:stories_after_resource_has_many]
                        instance_exec story, {}, &options[:stories_after_resource_has_many]
                      end
                    end
                  end
                end
                
                project.item :comments, I18n.t('comments.index.title'), "#{project_path(@project)}#comments" do |comments|
                  comments.item(:new, I18n.t('general.new'), new_project_comment_path(@project)) if @comment
                  
                  if @comment.try(:id) && can?(:edit, @comment)
                    comments.item(:edit, I18n.t('general.edit'), edit_comment_path(@comment))
                  end
                end
                
                if options[:after_resource_has_many]
                  instance_exec project, {}, &options[:after_resource_has_many]
                end
              end
            end  
          end
        end  
      when :users
        Proc.new do |primary, options|
          primary.item :users, I18n.t('users.index.title'), users_path do |users|
            unless (@user.new_record? rescue true) || current_user.try(:id) == @user.id
              users.item :show, I18n.t('general.details'), "#{user_path(@user)}#top"
              
              users.item :projects, I18n.t('projects.index.title'), user_projects_path(@user)
              
              if options[:after_resource_has_many]
                instance_exec users, {}, &options[:after_resource_has_many]
              end
            end
          end
        end
      when :workflow
        Proc.new do |primary, options|
          if user_signed_in?
            primary.item :workflow, I18n.t('workflow.index.title'), workflow_path do |workflow|
              workflow.item :project_owner, I18n.t('workflow.project_owner.index.title'), workflow_project_owner_index_path do |project_owner|
                if options[:project_owner_menu_items]
                  instance_exec project_owner, {}, &options[:project_owner_menu_items]
                end
              end
              
              workflow.item :user, I18n.t('workflow.user.index.title'), workflow_user_index_path do |user|
                ::Voluntary::Navigation::Base.products.each do |slug, key|
                  text = I18n.t(key)
                  
                  user.item slug.gsub('-', '_').to_sym, text, product_workflow_user_index_path(slug) do |product|
                    product_slug = @story ? (@story.product.try(:to_param) || 'no-name') : 'no-name'
                    
                    unless (@story.new_record? rescue true) || product_slug != slug
                      product.item(:show, @story.name, story_path(@story)) do |story|
                        story.item :show, I18n.t('general.details'), "#{story_path(@story)}#top"
                      
                        story.item :tasks, I18n.t('tasks.index.title'), tasks_workflow_user_index_path(@story) do |tasks|
                          unless (@task.new_record? rescue true)
                            tasks.item(:edit, @task.name, edit_task_workflow_user_index_path(@task))
                          end
                        end
                      end
                    end
                    
                    product.item :next_task, I18n.t('workflow.user.tasks.next.title'), next_task_workflow_user_index_path('text-creation')
                  end
                end
              end
            end
          end
        end
      when :authentication
        Proc.new do |primary, options|
          if user_signed_in?
            primary.item :profile, I18n.t('users.show.title'), user_path(current_user) do |profile|
              profile.item :show, I18n.t('users.show.title'), user_path(current_user) do |user|
                user.item :show, I18n.t('users.show.title'), "#{user_path(current_user)}#top"
                user.item :settings, I18n.t('users.edit.title'), edit_user_path(current_user)
                user.item :preferences, I18n.t('users.preferences.title'), preferences_user_path(current_user)
                user.item :projects, I18n.t('projects.index.title'), user_projects_path(current_user)
                
                if options[:profile_menu_items]
                  instance_exec user, {}, &options[:profile_menu_items]
                end
              end
            end
            
            primary.item :sign_out, I18n.t('authentication.sign_out'), destroy_user_session_path, method: :delete
          else
            primary.item :authentication, I18n.t('authentication.title'), new_user_session_path do |authentication|
              authentication.item :sign_in, I18n.t('authentication.sign_in'), new_user_session_path
              #authentication.item :rpx_sign_in, I18n.t('authentication.rpx_sign_in'), 'a' # link_to_rpx
              authentication.item :sign_up, I18n.t('authentication.sign_up'), new_user_registration_path
            end
          end
        end
      else
        Proc.new do |primary, options|
          ::Voluntary::Navigation::Base.core_menu_codes.each do |working_resource, code|
            next unless working_resource == resource
            
            instance_exec primary, ::Voluntary::Navigation::Base.menu_options(resource), &code
          end
        end
      end
    end
  end
end