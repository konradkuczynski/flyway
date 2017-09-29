# Define flyway::migrate allow to sets parameters of file *.conf and starts migration
define flyway::migrate (
  $url,
  $user,
  $password,
  $ensure                 = 'present',
  $sqlprefix              = 'V',
  $encoding               ='UTF-8',
  $initonmigrate          = true,
  $initversion            = '1',
  $validateonmigrate      = true,
  $cleanonvalidationerror = false,
  $outoforder             = false,
  $logoutput              = true,) {
  include flyway::params
  include flyway

  $config_file = "${flyway::params::flyway_dir}/conf/${name}.properties"

  file { "flyway::config::${name}":
    ensure  => file,
    path    => $config_file,
    mode    => '0600',
    content => template('flyway/config.properties.erb'),
  }
  case $ensure {
    'present' : {
      exec { "flyway::migrate::${name}":
        command   => "${flyway::params::flyway_dir}/flyway \\
              -configFile=${config_file} \\
              migrate",
        onlyif    => "${flyway::params::flyway_dir}/flyway \\
              -configFile=${config_file} \\
              info | egrep '(Pending|ERROR)'",
        require   => [
                        Anchor['flyway::end'],
                        File["flyway::config::${name}"],
                        ],
        logoutput => $logoutput,
      }
    }
    'absent'  : {
      exec { "flyway::clean::${name}":
        command   => "${flyway::params::flyway_dir}/flyway \\
              -configFile=${config_file} \\
              clean",
        onlyif    => "${flyway::params::flyway_dir}/flyway \\
          -configFile=${config_file} \\
          -password=${password} \\
          info | egrep '(Success|Future|ERROR)'",
        require   => [
                        Anchor['flyway::end'],
                        File["flyway::config::${name}"],
                        ],
        logoutput => $logoutput,
      }
    }
    default   : {
      fail('ensure must be either: present or absent')
    }
  }
}
