RSpec.shared_examples :a_base_object do
  it 'has object' do
    expect(subject.object).to eq(object)
  end

  it 'type' do
    # test that a valid object method exists
    expect(subject).to respond_to(:class)
  end

  it 'expected raise errors' do
    expected_attributes.each do |attribute|
      expect { subject.send(attribute) }.to raise_error(error_class)
    end
  end
end
