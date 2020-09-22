require "rails_helper"

RSpec.describe TeacherTrainingAdviser::Steps::SubjectTaught do
  include_context "wizard step"
  it_behaves_like "a wizard step"
  it_behaves_like "a wizard step that exposes API types as options", :get_teaching_subjects

  context "attributes" do
    it { is_expected.to respond_to :subject_taught_id }
  end

  describe ".options" do
    it "does not return the No Preference option" do
      types = [
        GetIntoTeachingApiClient::TypeEntity.new(id: "1", value: "one"),
        GetIntoTeachingApiClient::TypeEntity.new(id: described_class::NO_PREFERENCE_ID, value: "two"),
      ]

      allow_any_instance_of(GetIntoTeachingApiClient::TypesApi).to \
        receive(:get_teaching_subjects) { types }

      expect(described_class.options.values).to_not include(described_class::NO_PREFERENCE_ID)
    end
  end

  describe "#subject_taught_id" do
    it "allows a valid subject_taught_id" do
      subject_type = GetIntoTeachingApiClient::TypeEntity.new(id: "abc-123")
      allow_any_instance_of(GetIntoTeachingApiClient::TypesApi).to \
        receive(:get_teaching_subjects) { [subject_type] }
      expect(subject).to allow_value(subject_type.id).for :subject_taught_id
    end

    it { is_expected.to_not allow_values("", nil, "invalid-id").for :subject_taught_id }
  end

  describe "#skipped?" do
    it "returns false if returning_to_teaching is true" do
      wizardstore["returning_to_teaching"] = true
      expect(subject).to_not be_skipped
    end

    it "returns true if returning_to_teaching is false" do
      wizardstore["returning_to_teaching"] = false
      expect(subject).to be_skipped
    end
  end

  describe "#reviewable_answers" do
    subject { instance.reviewable_answers }
    let(:type) { GetIntoTeachingApiClient::TypeEntity.new(id: "123", value: "Value") }
    before do
      allow_any_instance_of(GetIntoTeachingApiClient::TypesApi).to \
        receive(:get_teaching_subjects) { [type] }
      instance.subject_taught_id = type.id
    end

    it { is_expected.to eq({ "subject_taught_id" => "Value" }) }
  end
end
