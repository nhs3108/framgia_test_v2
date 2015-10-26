class Question < ActiveRecord::Base
  include RailsAdminQuestion
  include RailsAdmin::Engine.routes.url_helpers

  belongs_to :subject
  belongs_to :user

  enum state: [:waiting, :accepted, :rejected]
  enum question_type: [:single_choice, :multiple_choice, :text]

  has_many :options, dependent: :destroy
  has_many :exams, through: :results
  has_many :results

  validates :content, presence: true

  accepts_nested_attributes_for :options, allow_destroy: true

  scope :systems, ->{where user_id: User.select(:id).where(admin: true)}
  scope :suggestion, ->{where user_id: User.select(:id).where(admin: false)}
  scope :rejected, ->{where state: 2}
  scope :waiting, ->{where state: 0}
  scope :most_failed, ->(quantity){joins(:results).where("results.correct is false")
    .group(:id).order("COUNT(results.question_id) DESC").limit(quantity)}

  def active_question
    active? ? I18n.t("questions.labels.question_active").html_safe : I18n.t("questions.labels.question_deactive").html_safe
  end

  def self.most_failed_json quantity
    Question.most_failed(quantity).eager_load(:results).map do |question|
      {
        id: question.id,
        frequency: question.results.incorrects.count,
        url: "#{RailsAdmin::Engine.routes.url_helpers
          .show_question_path("Question", question)}"
      }
    end.to_json
  end

  def self.import_csv file, user
    begin
      CSV.open(file.path, "rt", headers: true).each do |row|
        content = row["content"]
        state = row["state"]
        subject = row["subject"]
        type = row["type"]
        active = row["active"]
        options_data = JSON.parse row["options_data"]

        ActiveRecord::Base.transaction do
          subject = Subject.create name: subject, chatwork_room_id: 1,
            number_of_question: 1, duration: 1
          question = subject.questions.create content: content, state: state.to_i,
            question_type: type.to_i, active: active, user_id: user.id
          options_data.each do |option_data|
            question.options.create option_data.to_hash
          end
        end
      end
    rescue Exception => e
      raise e
    end
  end
end
