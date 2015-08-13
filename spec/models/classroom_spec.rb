require 'rails_helper'

RSpec.describe Classroom, :type => :model do

  context "attributes validation" do
    context 'student_id' do
      it { should respond_to :student_id }
      it { should validate_presence_of(:student_id) }
    end

    context 'course_id' do
      it { should respond_to :course_id }
      it { should validate_presence_of(:course_id) }
    end

    context 'entry_at' do
      it { should respond_to :entry_at}
      it { should validate_presence_of(:entry_at) }
    end

    context 'student_id + course_id uniqueness' do
      it { should validate_uniqueness_of(:student_id).scoped_to(:course_id) }
    end

  end

  describe '#create' do
    context 'when valid content' do
      before :each do
        FactoryGirl.create :student
        FactoryGirl.create :course
        @classroom = FactoryGirl.create :classroom
      end
      it "returns classroom instance" do
        expect(@classroom).to be_kind_of(Classroom)
      end
      it "returns Classroom record, with correct attributes" do
        expect(@classroom.student_id).to eq 1
        expect(@classroom.course_id).to  eq 1
        expect(@classroom.entry_at).to   eq "2015-08-13 12:59:24".to_datetime.strftime
      end
    end
    context 'when invalid content' do
      context 'and student_id + course_id already exists' do
        before :each do
          @classroom = FactoryGirl.create :classroom
          @classroom_02 = Classroom.new student_id: 1, course_id: 1
        end
        it "returns valid? false" do
          expect(@classroom.valid?).to be_truthy
          expect(@classroom_02.valid?).to be_falsy
        end
        it "returns error messages" do
          expect(@classroom.errors.messages.empty?).to be_truthy
          @classroom_02.save
          expect(@classroom_02.errors.messages.empty?).to be_falsy
        end
      end
    end
  end

end
