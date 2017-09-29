require 'spec_helper_acceptance'
# Tests for define lyway::loadsql::zip
describe 'flyway::loadsql::zip', unless: UNSUPPORTED_PLATFORMS.include?(fact('osfamily')) do
  let(:pp) { example('flyway::loadsql::zip') }
  it 'should work with no errors' do
    result = apply_manifest(pp, catch_failures: true)
    expect(result.exit_code).to be(2)
  end
  it 'should work idempotently' do
    apply_manifest(pp, catch_changes: true)
  end
  describe file('/opt/flyway-4.2.0/sql/pesel') do
    it { is_expected.to exist }
    it { is_expected.to be_directory }
  end
end
