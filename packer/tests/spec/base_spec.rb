require 'spec_helper'

packages = [
  'git',
  'curl',
  'libcurl3',
  'default-jre-headless',
  'unzip',
  'wget',
  'python-setuptools',
  'python-protobuf',
  'cgroup-bin',
  'ruby2.0',
  'auditd',
  'audispd-plugins'
]

packages.each do |package|
  describe package(package) do
    it { should be_installed }
  end
end
