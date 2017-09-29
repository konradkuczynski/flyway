require 'spec_helper_acceptance'
# Tests for define flyway::migrate
describe 'flyway::migrate', unless: UNSUPPORTED_PLATFORMS.include?(fact('osfamily')) do
  let(:migrate_pp) { example('flyway::migrate') }
  let(:loadsql_pp) { example('flyway::loadsql::ziplocal') }
  let(:pp) { loadsql_pp + "\n\n" + migrate_pp }

  # Preparing server for test cases
  shell 'puppet module install puppetlabs-postgresql'
  apply_manifest('include postgresql::server')
  it 'should have pgsql user' do
    apply_manifest(File.read('spec/fixtures/migrations/migratepgsql.pp'))
  end
  apply_manifest('package { "zip": ensure => installed, }')
  scp_to default, 'spec/fixtures/migrations/db_schema', '/usr/src/db_schema'
  shell ' zip -r /usr/src/db_schema.zip /usr/src/db_schema/'

  it 'should work with no errors' do
    result = apply_manifest(pp, catch_failures: true)
    expect(result.exit_code).to be(2)
  end
  it 'should work idempotently' do
    apply_manifest(pp, catch_changes: true)
  end
  describe file('/opt/flyway-4.2.0/conf/pgsql.properties') do
    it { is_expected.to exist }
  end
  describe command("flyway -configFile=/opt/flyway-4.2.0/conf/pgsql.properties info | awk '{ print $11 }'") do
    let(:expected_result) { 'Success' }
    its(:stdout) { is_expected.to match(/^#{Regexp.escape expected_result}$/) } # let definiuje wartosc a regexp zamienia . na /
  end
end
