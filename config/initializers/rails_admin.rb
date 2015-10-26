require Rails.root.join("lib", "rails_admin", "mark_exam.rb")
RailsAdmin::Config::Actions.register(RailsAdmin::Config::Actions::MarkExam)
require Rails.root.join("lib", "rails_admin", "edit_question.rb")
RailsAdmin::Config::Actions.register(RailsAdmin::Config::Actions::EditQuestion)
require Rails.root.join("lib", "rails_admin", "create_question.rb")
RailsAdmin::Config::Actions.register(RailsAdmin::Config::Actions::CreateQuestion)
require Rails.root.join("lib", "rails_admin", "show_question.rb")
RailsAdmin::Config::Actions.register(RailsAdmin::Config::Actions::ShowQuestion)
require Rails.root.join("lib", "rails_admin", "active_question.rb")
RailsAdmin::Config::Actions.register(RailsAdmin::Config::Actions::ActiveQuestion)
require Rails.root.join("lib", "rails_admin", "deactive_question.rb")
RailsAdmin::Config::Actions.register(RailsAdmin::Config::Actions::DeactiveQuestion)
require Rails.root.join("lib", "rails_admin", "multi_active_question.rb")
RailsAdmin::Config::Actions.register(RailsAdmin::Config::Actions::MultiActiveQuestion)
require Rails.root.join("lib", "rails_admin", "multi_deactive_question.rb")
RailsAdmin::Config::Actions.register(RailsAdmin::Config::Actions::MultiDeactiveQuestion)
require Rails.root.join("lib", "rails_admin", "dashboard.rb")
RailsAdmin::Config::Actions.register(RailsAdmin::Config::Actions::Dashboard)
require Rails.root.join("lib", "rails_admin", "import.rb")
RailsAdmin::Config::Actions.register(RailsAdmin::Config::Actions::Import)

RailsAdmin.config do |config|
  config.authenticate_with do
    warden.authenticate! scope: :user
  end

  config.current_user_method(&:current_user)

  config.authorize_with :cancan

  config.actions do
    import do
      only Question
    end
    dashboard
    index
    create_question do
      only Question
    end
    new do
      except ["Exam", "Question"]
    end
    export
    bulk_delete
    multi_active_question do
      only Question
    end
    multi_deactive_question do
      only Question
    end
    mark_exam
    show_question
    show do
      except "Question"
    end
    edit_question
    edit do
      except ["Exam", "Question"]
    end
    active_question do
      only Question
    end
    deactive_question do
      only Question
    end
    show_in_app do
      except ["User", "Exam"]
    end
  end
  config.excluded_models = ["Answer", "Option", "Result"]
end
