RSpec.shared_examples :a_stripe_object do
  it 'has object' do
    expect(subject.object).to eq(object)
  end

  it 'match stripe object' do
    expected_attributes.each do |attribute|
      expect(subject.send(attribute)).to eq(object.send(attribute))
    end
  end

  it 'raises error for undefined attribute' do
    expect { subject.send(:showoff) }.to raise_error(error_class)
  end
end
