# Installs flyway command line tool
class flyway (
  $flyway_ver                 = $flyway::params::flyway_ver,
  $flyway_file                = $flyway::params::flyway_file,
  $flyway_download_url        = $flyway::params::flyway_download_url,
  $java_version               = 'latest',
  $java_package               = undef,
  $flyway_commandline         = undef,
  $flyway_commandline_zipname = undef,
  $flyway_parent_dir          = $flyway::params::parent_dir,
  $flyway_checksum            = $flyway::params::flyway_checksum,
  ) inherits flyway::params {

  if $flyway_commandline {
    $flyway_commandline_real = $flyway_commandline
  } else {
    $flyway_commandline_real = "${flyway_file}-${flyway_ver}"
  }
  if $flyway_commandline_zipname {
    $flyway_commandline_zipname_real = $flyway_commandline_zipname
  } else {
    $flyway_commandline_zipname_real = "${flyway_commandline_real}.${flyway::params::flyway_file_ext}"
  }
  anchor { 'flyway::begin': }

  if !defined(Class['java']) {
    class { 'java':
      distribution => 'jdk',
      version      => $java_version,
      package      => $java_package,
      require      => Anchor['flyway::begin'],
    }
  }
  ensure_packages ({ 'unzip' => {
    ensure  => installed,
    require => Anchor['flyway::begin'],}
  })
  file { $flyway::params::download_dir:
    ensure  => 'directory',
    require => Anchor['flyway::begin'],
  }
  # Download flyway-commandline
  fetchtool::download { "${flyway_download_url}/${flyway_file}-${flyway_ver}.${flyway::params::flyway_file_ext}":
    fetch_dir => $flyway::params::download_dir,
    mode      => '0755',
    owner     => 'root',
    group     => 'root',
    require   => Anchor['flyway::begin'],
  }
  # Unpack flyway-commandline
  archive { "${flyway::params::parent_dir}/${flyway_file}-${flyway_ver}.${flyway::params::flyway_file_ext}":
    ensure        => 'present',
    source        => "${flyway::params::download_dir}/${flyway_file}-${flyway_ver}.${flyway::params::flyway_file_ext}",
    extract       => true,
    extract_path  => $flyway::params::parent_dir,
    checksum      => $flyway::params::flyway_checksum,
    checksum_type => $flyway::params::flyway_checksum_type,
    require       => [
      File[$flyway::params::download_dir],
      Anchor['flyway::begin'],
      Fetchtool::Download["${flyway_download_url}/${flyway_file}-${flyway_ver}.${flyway::params::flyway_file_ext}"],
    ],
  }
  # Creation of symlink
  file { 'flyway-bin-symlink':
    ensure  => 'link',
    path    => '/usr/bin/flyway',
    target  => "${flyway::params::parent_dir}/flyway-${flyway_ver}/flyway",
    require => [
      Archive["${flyway::params::parent_dir}/${flyway_file}-${flyway_ver}.${flyway::params::flyway_file_ext}"],
      Anchor['flyway::begin'],
    ],
  }

  anchor { 'flyway::end':
    require  => [
      Archive["${flyway::params::parent_dir}/${flyway_file}-${flyway_ver}.${flyway::params::flyway_file_ext}"],
      Anchor['flyway::begin'],
    ]
  }
}
