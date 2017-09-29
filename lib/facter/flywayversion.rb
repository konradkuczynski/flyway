Facter.add(:flywayversion) do
  setcode do
    flyway = Facter.value(:flyway)
    ret = (flyway.gsub(/.+v\.([\.0-9]+)$/, '\1') if flyway != 'not installed')
    ret
  end
end
