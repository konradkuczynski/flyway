# Define flyway::loadsql::zip downloading zip file from url or disk and unpackig it  and creating symlink
#
# = Params:
#
# * [source] - Namevar. An network address with for ex.: http:// or local file
# * [namespace] - Required. A directory namespace in Flyway SQL directory
define flyway::loadsql::zip (
  $namespace,
  $source     = $name,
  $attributes = {},
  ) {

  include flyway::params
  include flyway

  $fetchdir = '/usr/src'
  $basename = fqdn_rand(65535, $name)
  $filename = "flyway-loadsql-${basename}.zip"
  $downloaded_zip = "${fetchdir}/${filename}"
  $target = "${flyway::params::flyway_sql_dir}/${namespace}"
  # $archive_path parameter - extract_path must be on path of this variable
  $archive_path = "${flyway::params::flyway_sql_dir}/${namespace}/${filename}"

  file { $target:
    ensure => 'directory'
  }
  case $source {
    /^(?:http|https|ftp|sftp|ftps):/ : {
      # downloading from network

      # Download flyway-commandline
      fetchtool::download { $source:
        fetch_dir  => $fetchdir,
        filename   => $filename,
        mode       => '0644',
        owner      => 'root',
        group      => 'root',
        attributes => $attributes,
      }
      archive { $archive_path:
        ensure       => present,
        source       => $downloaded_zip,
        extract      => true,
        extract_path => $target,
        cleanup      => true,
        require      => [
          Fetchtool::Download[$source],
          File[$target],
        ],
      }
    }
    default: {
      # method for local file
      archive { $archive_path:
        ensure       => present,
        source       => $source,
        extract      => true,
        extract_path => $target,
        cleanup      => true,
        require      => File[$target],
      }
    }
  }
}
