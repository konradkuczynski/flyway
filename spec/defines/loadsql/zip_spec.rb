require 'spec_helper_puppet'

shared_examples 'a working flyway::loadsql::zip defines' do
  it { is_expected.to compile }
  it { is_expected.to contain_class('flyway') }
end

describe 'flyway::loadsql::zip', type: :define do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'with url' do
        let(:title) { 'http://example.org/mydb.zip' }
        let(:params) do
          {
            namespace: 'db_postgres'
          }
        end
        it_behaves_like 'a working flyway::loadsql::zip defines'
        it { is_expected.to contain_fetchtool__download('http://example.org/mydb.zip') }
        it { is_expected.to contain_archive('/opt/flyway-4.2.0/sql/db_postgres/flyway-loadsql-1757.zip') }
        it { is_expected.to contain_file('/opt/flyway-4.2.0/sql/db_postgres') }
      end
      context 'with zip on disc' do
        let(:title) { '/usr/mydb.zip' }
        let(:params) do
          {
            namespace: 'db_oracle'
          }
        end
        it_behaves_like 'a working flyway::loadsql::zip defines'
        it { is_expected.to contain_archive('/opt/flyway-4.2.0/sql/db_oracle/flyway-loadsql-15609.zip') }
        it { is_expected.to contain_file('/opt/flyway-4.2.0/sql/db_oracle') }
      end
    end
  end
end
