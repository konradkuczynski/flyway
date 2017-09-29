# Class contains parameters for flyway
class flyway::params (
  $flyway_ver           = '4.2.0',
  $flyway_file          = 'flyway-commandline',
  $flyway_file_ext      = 'zip',
  $parent_dir           = '/opt',
  $flyway_checksum      = '86cb7cca7d7fef18a7f7cbc8c8b32184',
  $flyway_checksum_type = 'md5',
  ) {
  $download_dir       = "${parent_dir}/download"
  $flyway_basedir     = "flyway-${flyway_ver}"
  $flyway_dir         = "${parent_dir}/${flyway_basedir}"
  $flyway_jar_dir     = "${flyway_dir}/jars"
  $flyway_sql_dir     = "${flyway_dir}/sql"

  $flyway_download_url = "http://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/${flyway_ver}"
}
