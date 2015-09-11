module RailsAdmin
  module Config
    module Actions
      class MarkExam < RailsAdmin::Config::Actions::Base

        register_instance_option :visible? do
          authorized? && bindings[:object].class == Exam
        end

        register_instance_option :member do
          true
        end

        register_instance_option :http_methods do
          [:get, :post]
        end

        register_instance_option :link_icon do
          "icon-ok"
        end

        register_instance_option :pjax? do
          false
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

        register_instance_option :controller do
          proc do
            if request.get?
              if object.testing? || object.start?
                redirect_to :back || root_path
              else
                render action: @action.template_name
              end

            elsif request.post?
              exam_params = params.require(:exam).permit(results_attributes: [:id, :correct])
              if object.update_attributes exam_params
                object.update_attributes score: object.calculate_score,
                status: :checked

                object.send_score_to_chatwork current_user if current_user.chatwork_api_key?

                flash[:notice] = t "flashs.messages.submit_success"
              else
                flash[:alert] = t "flashs.messages.invalid"
              end
                redirect_to :back
            end
          end
        end

        def key
          self.class.key
        end
      end
    end
  end
end
