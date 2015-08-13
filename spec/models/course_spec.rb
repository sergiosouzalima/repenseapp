require 'rails_helper'

RSpec.describe Course, :type => :model do

  context "attributes validation" do
    context 'name' do
      it { should respond_to :name }
      it { should validate_presence_of(:name) }
      it { should validate_uniqueness_of(:name) }
    end

    context 'description' do
      it { should respond_to :description }
      it { should validate_presence_of(:description) }
    end

    context 'status' do
      it { should respond_to :status}
    end

  end

  describe '#create' do
    context 'when valid content' do
      before :each do
        @course = FactoryGirl.create :course
      end
      it "returns Course instance" do
        expect(@course).to be_kind_of(Course)
      end
      it "returns Course record, with correct attributes" do
        expect(@course.name).to            eq "Computing Science"
        expect(@course.description).to     eq "Computing Science Master Degree"
        expect(@course.status).to          eq 1
      end
    end
    context 'when invalid content' do
      context 'and name already exists' do
        before :each do
          @course = FactoryGirl.create :course
          @course_02 = Course.new name: "Computing Science", description: "Computing Science Master Degree", status: 2
        end
        it "returns valid? false" do
          expect(@course.valid?).to be_truthy
          expect(@course_02.valid?).to be_falsy
        end
        it "returns error messages" do
          expect(@course.errors.messages.empty?).to be_truthy
          @course_02.save
          expect(@course_02.errors.messages.empty?).to be_falsy
        end
      end
      context 'and description already exists' do
        before :each do
          @course = FactoryGirl.create :course
          @course_02 = Course.new name: "Computing Science", description: "Computing Science Master Degree", status: 2
        end
        it "returns valid? false" do
          expect(@course.valid?).to be_truthy
          expect(@course_02.valid?).to be_falsy
        end
        it "returns error messages" do
          expect(@course.errors.messages.empty?).to be_truthy
          @course_02.save
          expect(@course_02.errors.messages.empty?).to be_falsy
        end
      end
      context 'and name is larger then maximum' do
        before :each do
          @course = Course.new name: "X" * 46, description: "Computing Science Master Degree"
        end
        it "returns valid? false" do
          expect(@course.valid?).to be_falsy
        end
        it "returns error messages" do
          @course.save
          expect(@course.errors.messages.empty?).to be_falsy
        end
      end
      context 'and description is larger then maximum' do
        before :each do
          @course = Course.new name: 'Computing Science', description: 'X' * 46
        end
        it "returns valid? false" do
          expect(@course.valid?).to be_falsy
        end
        it "returns error messages" do
          @course.save
          expect(@course.errors.messages.empty?).to be_falsy
        end
      end
    end
  end

  context "course x classrooms" do
    before do
      s1 = FactoryGirl.create :student
      s2 = FactoryGirl.create :student, id: 2, name: "Nico Smith",   register_number: "12345679"
      s3 = FactoryGirl.create :student, id: 3, name: 'Ben Johnson',  register_number: "12345670"
      c1 = FactoryGirl.create :course,  name: 'Psychology'
      c2 = FactoryGirl.create :course,  id: 2, name: 'Maths'
      @classroom_01 = FactoryGirl.create( :classroom, student_id: s1.id, course_id: c1.id )
      FactoryGirl.create( :classroom, student_id: s1.id, course_id: c2.id )
      FactoryGirl.create( :classroom, student_id: s2.id, course_id: c1.id )
      FactoryGirl.create( :classroom, student_id: s2.id, course_id: c2.id )
    end

    it "has relationship" do
      expect(@classroom_01.course.id).to eq 1
      expect(Course.find(1).classrooms.count).to eq 2
      expect(Course.find(2).classrooms.count).to eq 2
    end
  end

end
