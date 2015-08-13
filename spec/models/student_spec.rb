require 'rails_helper'

RSpec.describe Student, :type => :model do

  context "attributes validation" do
    context 'name' do
      it { should respond_to :name }
      it { should validate_presence_of(:name) }
      it { should validate_uniqueness_of(:name) }
    end

    context 'register_number' do
      it { should respond_to :register_number }
      it { should validate_presence_of(:register_number) }
      it { should validate_uniqueness_of(:register_number) }
    end

    context 'status' do
      it { should respond_to :status}
    end

  end

  describe '#create' do
    context 'when valid content' do
      before :each do
        @student = FactoryGirl.create :student
      end
      it "returns Student instance" do
        expect(@student).to be_kind_of(Student)
      end
      it "returns Student record, with correct attributes" do
        expect(@student.name).to            eq "John Smith"
        expect(@student.register_number).to eq "12345678"
        expect(@student.status).to           eq 1
      end
    end
    context 'when invalid content' do
      context 'and name already exists' do
        before :each do
          @student = FactoryGirl.create :student
          @student_02 = Student.new name: "John Smith", register_number: "12121212", status: 2
        end
        it "returns valid? false" do
          expect(@student.valid?).to be_truthy
          expect(@student_02.valid?).to be_falsy
        end
        it "returns error messages" do
          expect(@student.errors.messages.empty?).to be_truthy
          @student_02.save
          expect(@student_02.errors.messages.empty?).to be_falsy
        end
      end
      context 'and register_number already exists' do
        before :each do
          @student = FactoryGirl.create :student
          @student_02 = Student.new name: "Johnny Depp", register_number: "12345678", status: 1
        end
        it "returns valid? false" do
          expect(@student.valid?).to be_truthy
          expect(@student_02.valid?).to be_falsy
        end
        it "returns error messages" do
          expect(@student.errors.messages.empty?).to be_truthy
          @student_02.save
          expect(@student_02.errors.messages.empty?).to be_falsy
        end
      end
      context 'and name is larger then maximum' do
        before :each do
          @student = Student.new name: "X" * 46, register_number: '12345678'
        end
        it "returns valid? false" do
          expect(@student.valid?).to be_falsy
        end
        it "returns error messages" do
          @student.save
          expect(@student.errors.messages.empty?).to be_falsy
        end
      end
      context 'and register_number is larger then maximum' do
        before :each do
          @student = Student.new name: 'John Smith', register_number: '9' * 46
        end
        it "returns valid? false" do
          expect(@student.valid?).to be_falsy
        end
        it "returns error messages" do
          @student.save
          expect(@student.errors.messages.empty?).to be_falsy
        end
      end
    end
  end

  context "student x classrooms" do
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
      expect(@classroom_01.student.id).to eq 1
      expect(Student.find(1).classrooms.count).to eq 2
      expect(Student.find(2).classrooms.count).to eq 2
    end
  end

end
