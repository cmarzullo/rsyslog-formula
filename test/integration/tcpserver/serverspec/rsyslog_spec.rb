require 'serverspec'
require 'socket'

# Required by serverspec
set :backend, :exec

describe package('rsyslog') do
  it { should be_installed }
end

describe file('/etc/rsyslog.conf') do
  it { should exist }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  it { should be_mode 644 }
  its(:content) { should match /\$ModLoad imuxsock/ }
end

describe file('/etc/rsyslog.d/tcp-client-server.conf') do
  it { should exist }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  it { should be_mode 644 }
  its(:content) { should match /tcp-client-server/ }
  its(:content) { should match /name="Syslog"/ }
  its(:content) { should match /name="RemoteDevice"/ }
  its(:content) { should match /load="imtcp"/ }
  its(:content) { should match /type="imtcp"/ }
  its(:content) { should match /type="omfwd"/ }
  its(:content) { should match /Protocol="tcp"/ }
  its(:content) { should match /template="RSYSLOG_TraditionalFileFormat"/ }
end

hostname = Socket.gethostname
describe file("/tmp/#{hostname}.log") do
  it { should exist }
end

describe port('514') do
  it { should be_listening.with('tcp') }
end

describe process('rsyslogd') do
  it { should be_running }
  its(:user) { should eq 'root' }
  its(:args) { should match /-n/ }
end
