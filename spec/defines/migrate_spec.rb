require 'spec_helper_puppet'

shared_examples 'a working flyway::migrate define' do
  it { is_expected.to compile }
  it { is_expected.to contain_class('flyway') }
  it {
    is_expected.to contain_file('flyway::config::oracle').with(
      path: '/opt/flyway-4.2.0/conf/oracle.properties'
    )
  }
end

describe 'flyway::migrate', type: :define do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end
      context 'with parameter ensure = present' do
        let(:title) { 'oracle' }
        let(:params) do
          {
            url: 'jdbc:h2:file:./foobardb',
            user: 'SA',
            password: ''
          }
        end
        it_behaves_like 'a working flyway::migrate define'
        it {
          is_expected.to contain_exec('flyway::migrate::oracle').with(
            command: '/opt/flyway-4.2.0/flyway \\
              -configFile=/opt/flyway-4.2.0/conf/oracle.properties \\
              migrate'
          )
        }
      end
      context 'with parameter ensure = absent' do
        let(:title) { 'oracle' }
        let(:params) do
          {
            ensure: 'absent',
            url: 'jdbc:h2:file:./foobardb',
            user: 'SA',
            password: ''
          }
        end
        it_behaves_like 'a working flyway::migrate define'
        it {
          is_expected.to contain_exec('flyway::clean::oracle').with(
            command: '/opt/flyway-4.2.0/flyway \\
              -configFile=/opt/flyway-4.2.0/conf/oracle.properties \\
              clean'
          )
        }
      end
    end
  end
end
