class Result < ActiveRecord::Base
  belongs_to :exam
  belongs_to :question

  has_many :answers, dependent: :destroy
  has_many :options, through: :answers

  after_create :create_answers

  accepts_nested_attributes_for :answers
  scope :incorrects, ->{where correct: false}

  def create_answers
    answers.create unless question.multiple_choice?
  end

  def result_status
    if exam.checked?
      status = correct? ? I18n.t("questions.labels.correct") : I18n.t("questions.labels.wrong")
    end
    status ||= ""
  end

  def result_correct_count?
    Answer.option_correct(id) == Option.count_correct_option(question_id)
  end

  def check_result
    if self.question.question_type == "text"
      self.update correct: self.answers.first.content.strip ==
        self.question.options.first.content.strip ? true : nil
    else
      self.update correct: Answer.not_correct(self.id) <= 0 && Answer.option_correct(self.id) > 0
    end
  end
end
