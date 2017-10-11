#!/opt/puppetlabs/bin/puppet apply
$pkg = case $::osfamily {
  'redhat': 'httpd',
  'debian': 'apache2'}
package {$pkg: ensure => present }
