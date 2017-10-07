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
describe file('/etc/rsyslog.d/udp-client-server.conf') do
  it { should exist }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  it { should be_mode 644 }
  its(:content) { should match /udp-client-server/ }
  its(:content) { should match /name="Syslog"/ }
  its(:content) { should match /name="RemoteDevice"/ }
  its(:content) { should match /load="imudp"/ }
  its(:content) { should match /type="imudp"/ }
  its(:content) { should match /type="omfwd"/ }
  its(:content) { should match /Protocol="udp"/ }
end

hostname = Socket.gethostname
describe file("/tmp/#{hostname}.log") do
  it { should exist }
end

describe port('514') do
  it { should be_listening.with('udp') }
end

describe process('rsyslogd') do
  it { should be_running }
  its(:user) { should eq 'root' }
  its(:args) { should match /-n/ }
end
