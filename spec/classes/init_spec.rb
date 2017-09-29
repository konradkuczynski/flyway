require 'spec_helper_puppet'

describe 'flyway', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) { facts.merge(flyway: 'not installed') }

      context 'with default values for all parameters' do
        it { is_expected.to compile }
        it { is_expected.to contain_class('flyway') }
        it { is_expected.to contain_class('flyway::params') }
        it { is_expected.to contain_anchor('flyway::begin') }
        it { is_expected.to contain_anchor('flyway::end') }
        let(:params) do
          {
            java_version: '1.1'
          }
        end
        it {
          is_expected.to contain_class('java').with(
            distribution: 'jdk',
            version: '1.1'
          )
        }
        it {
          is_expected.to contain_file('/opt/download').with(
            ensure: 'directory'
          )
        }
        it { is_expected.to contain_package('unzip') }
        it {
          is_expected.to contain_archive('/opt/flyway-commandline-4.2.0.zip').with(
            ensure: 'present'
          )
        }
        it {
          is_expected.to contain_file('flyway-bin-symlink').with(
            ensure: 'link',
            path: '/usr/bin/flyway',
            target: '/opt/flyway-4.2.0/flyway'
          )
        }
        it {
          is_expected.to contain_fetchtool__download('http://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/4.2.0/flyway-commandline-4.2.0.zip')
        }
      end
    end
  end
end
