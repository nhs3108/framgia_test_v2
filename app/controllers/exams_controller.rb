class ExamsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  before_action :correct_user?, only: [:show, :update]

  def index
    @exam = Exam.new
    @subjects = Subject.order :name
    @exams = current_user.exams.page(params[:page]).order "created_at DESC"
  end

  def show
    @subject = @exam.subject
    if @exam.start?
      @exam.create_result @subject
      @exam.update_attribute :status, :testing
    end
    @duration = @exam.duration
  end

  def create
    @exam = current_user.exams.build exam_params
    if @exam.save
      flash[:notice] = flash_message "created"
      redirect_to exams_path
    else
      flash.now[:alert] = t "flashs.messages.exam_create_reject", subject: @exam.subject.name
    end
  end

  def update
    @exam.update_attributes time: @exam.spent_time
    if @exam.time_out? || params[:commit] == Settings.exam.state.finish
      @exam.update_attributes status: :unchecked
    end

    if @exam.update_attributes exam_params
      @exam.set_mark
      flash[:notice] = t "flashs.messages.submit_success"
    else
      flash[:alert] = t "flashs.messages.invalid"
    end
    redirect_to exams_url
  end


  private
  def exam_params
    params.require(:exam).permit :subject_id,
      results_attributes: [:id, option_ids: [], answers_attributes: [:id, :content, :option_id]]
  end

  def correct_user?
    redirect_to root_path unless current_user == @exam.user
  end
end
