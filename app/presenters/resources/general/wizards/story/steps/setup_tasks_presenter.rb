class Resources::General::Wizards::Story::Steps::SetupTasksPresenter < Presenter
  def form_options
    { html: {class: 'form-horizontal'}, url: story_path(resource), as: :story }
  end
end