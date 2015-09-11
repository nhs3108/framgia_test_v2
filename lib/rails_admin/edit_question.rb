module RailsAdmin
  module Config
    module Actions
      class EditQuestion < RailsAdmin::Config::Actions::Base
        register_instance_option :visible? do
          authorized? && bindings[:object].class == Question
        end

        register_instance_option :member do
          true
        end

        register_instance_option :link_icon do
          "icon-pencil"
        end

        register_instance_option :pjax? do
          true
        end

        register_instance_option :breadcrumb_parent do
          [:show_question, bindings[:abstract_model], bindings[:object]]
        end

        register_instance_option :http_methods do
          [:get, :post]
        end

        register_instance_option :route_fragment do
          custom_key.to_s
        end

        register_instance_option :action_name do
          custom_key.to_sym
        end

        register_instance_option :custom_key do
          key
        end

        def key
          self.class.key
        end

        register_instance_option :controller do
          Proc.new do
            if request.post?
              question_params = params.require(:question).permit :content, :subject_id, :user_id,
              :state, :question_type, :active, options_attributes: [:id, :content, :correct, :_destroy]
              if object.update_attributes question_params
                redirect_to show_question_path(Question, object), notice: flash_message("update_question")
              else
                render "edit_question"
              end
            end
          end
        end
      end
    end
  end
end
