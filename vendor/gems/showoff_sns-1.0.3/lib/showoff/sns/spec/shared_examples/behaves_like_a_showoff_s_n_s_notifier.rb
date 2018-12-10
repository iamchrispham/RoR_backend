RSpec.shared_examples :a_sns_notifier do
  it { expect(subject.notification.persisted?).to be(true) }

  it { should belong_to(:notification) }
  it { should belong_to(:owner) }

  it { should validate_presence_of(:notification) }
  it { should validate_presence_of(:owner) }

  it { should validate_uniqueness_of(:notification) }

  it { should respond_to(:resources) }

  it 'should create notification before validation if none present' do
    fresh_subject = subject.dup

    fresh_subject.notification = nil
    fresh_subject.valid?

    expect(fresh_subject.notification.present?).to be(true)
  end

  it 'should create owner before validation if none present' do
    fresh_subject = subject.dup

    fresh_subject.owner = nil
    fresh_subject.valid?

    expect(fresh_subject.owner.present?).to be(true)
  end

  it 'calls sends notification on creation' do
    expect(subject).to receive(:send_notification)

    subject.run_callbacks(:commit)
  end

  it 'calls notification send notification' do
    expect(subject.notification).to receive(:send_notification)

    subject.send_notification
  end
end
