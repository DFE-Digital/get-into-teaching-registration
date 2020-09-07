module TeacherTrainingAdviser::Steps
  class OverseasCallback < Wizard::Step
    extend CallbackBookingQuotas
    
    attribute :phone_call_scheduled_at, :datetime

    validates :phone_call_scheduled_at, presence: true

    def reviewable_answers
      {
        "callback_date" => phone_call_scheduled_at.to_date,
        "callback_time" => phone_call_scheduled_at.to_time, # rubocop:disable Rails/Date
      }
    end

    def skipped?
      returning_teacher = @store["returning_to_teaching"]
      not_equivalent_degree = @store["degree_options"] != TeacherTrainingAdviser::Steps::HaveADegree::DEGREE_OPTIONS[:equivalent]
      not_overseas = @store["uk_or_overseas"] != TeacherTrainingAdviser::Steps::UkOrOverseas::OPTIONS[:overseas]

      returning_teacher || not_equivalent_degree || not_overseas
    end
  end
end
