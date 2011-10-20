shared_examples_for 'an ObjectId type' do
  describe '#valid?' do
    subject { property.valid?(value) }

    context 'with a BSON::ObjectId' do
      let(:value) { BSON::ObjectId.new }
      it { should be_true }
    end

    context 'with nil' do
      let(:value) { nil }
      it { should be_true }
    end
  end

  describe '#typecast' do
    subject { property.typecast(value) }

    context 'with a valid string' do
      let(:value) { '4d7b57618f9f1f12bd000002' }

      it 'should return BSON::ObjectId' do
        should == ::BSON::ObjectId.from_string(value)
      end
    end

    context 'with an invalid string' do
      let(:value) { '#invalid#' }
      it 'should raise BSON::InvalidObjectId' do
        lambda { subject }.should raise_error(::BSON::InvalidObjectId)
      end
    end

    context 'with nil' do
      let(:value) { nil }
      it 'should return nil' do
        should be_nil
      end
    end

   #context 'with anything else' do
   #  it 'should raise ArgumentError' do
   #    [ 0, 1, Object.new, true, false, [], {} ].each do |value|
   #      lambda {
   #        property.typecast(value)
   #      }.should raise_error(ArgumentError)
   #    end
   #  end
   #end
  end
end
