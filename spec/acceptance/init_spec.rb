require 'spec_helper_acceptance'
# Tests for class flyway
describe 'flyway', unless: UNSUPPORTED_PLATFORMS.include?(fact('osfamily')) do
  let(:pp) { example('flyway') }
  it 'should work with no errors' do
    result = apply_manifest(pp, catch_failures: true)
    expect(result.exit_code).to be(2)
  end
  it 'should work idempotently' do
    apply_manifest(pp, catch_changes: true)
  end
  describe file('/usr/bin/flyway') do
    it { is_expected.to exist }
    it { is_expected.to be_symlink }
  end
  describe file('/opt/download') do
    it { is_expected.to be_directory }
  end
  describe file('/opt/flyway-4.2.0/flyway') do
    it { is_expected.to exist }
  end
  describe package('unzip') do
    it { is_expected.to be_installed }
  end
  describe file('/opt/flyway-commandline-4.2.0.zip') do
    it { is_expected.to exist }
  end
end
