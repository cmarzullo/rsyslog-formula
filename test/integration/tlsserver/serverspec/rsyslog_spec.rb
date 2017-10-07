require 'serverspec'
require 'socket'

# Required by serverspec
set :backend, :exec

describe package('rsyslog') do
  it { should be_installed }
end

describe package('rsyslog-gnutls') do
  it { should be_installed }
end

describe file('/etc/rsyslog.conf') do
  it { should exist }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  it { should be_mode 644 }
  its(:content) { should match /\$ModLoad imuxsock/ }
  its(:content) { should match /\$DefaultNetstreamDriver gtls/ }
  its(:content) { should match /\$DefaultNetstreamDriverCAFile \/etc\/pki\/example_test_ca/ }
  its(:content) { should match /\$DefaultNetstreamDriverCertFile \/etc\/pki\/example_test_ca/ }
  its(:content) { should match /\$DefaultNetstreamDriverKeyFile \/etc\/pki\/example_test_ca/ }
  its(:content) { should match /\$PreserveFQDN on/ }
  its(:content) { should match /\$MaxMessageSize 32768/ }
end
describe file('/etc/rsyslog.d/tls-client-server.conf') do
  it { should exist }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  it { should be_mode 644 }
  its(:content) { should match /tls-client-server/ }
  its(:content) { should match /name="Syslog"/ }
  its(:content) { should match /name="Audit"/ }
  its(:content) { should match /local6.none/ }
  its(:content) { should match /name="RemoteDevice"/ }
  its(:content) { should match /load="imtcp"/ }
  its(:content) { should match /type="imtcp"/ }
  its(:content) { should match /type="omfwd"/ }
  its(:content) { should match /Protocol="tcp"/ }
  its(:content) { should match /template="RSYSLOG_TraditionalFileFormat"/ }
end

hostname = Socket.gethostbyname(Socket.gethostname).first
describe file("/tmp/#{hostname}/syslog.log") do
  it { should exist }
end
describe file("/tmp/#{hostname}/audit.log") do
  it { should exist }
end

describe port('514') do
  it { should be_listening.with('tcp') }
  it { should be_listening.with('tcp6') }
end

describe process('rsyslogd') do
  it { should be_running }
  its(:user) { should eq 'root' }
  its(:args) { should match /-n/ }
end
