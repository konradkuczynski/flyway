Facter.add(:flyway) do
  setcode do
    flbin = '/usr/bin/flyway'
    cmd = format('%s | head -n 1 2>/dev/null', flbin)
    begin
      line = Facter::Util::Resolution.exec(cmd).chomp
    rescue
      line = 'not installed'
    end
    line
  end
end
