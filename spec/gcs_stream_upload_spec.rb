RSpec.describe GCSStreamUpload do
  let(:bucket) { double(:bucket) }

  subject { GCSStreamUpload.new(bucket) }

  context '#upload' do
    it "passes correct parameters to create_file" do
      expect(bucket).to receive(:create_file).with(kind_of(IO), 'target')
      subject.upload('target') do
      end
    end
    it "reraises error in block" do
      allow(bucket).to receive(:create_file)
      expect do
        subject.upload('target') do
          raise StandardError, 'foo'
        end
      end.to raise_error('foo')
    end
  end
end
