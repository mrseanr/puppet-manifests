# This script will setup multiple zookeepers on a single server.
$esf = "/usr/tmp/ent_search"
$zkf = "${esf}/zookeeper"
$zk1f = "${zkf}/zk1"
$zk2f = "${zkf}/zk2"
$zk3f = "${zkf}/zk3"

# notify { "Zookeeper folder ${zk3f}": }

file { [ "${esf}",
	"${zkf}",
	"${zk1f}",
	"${zk2f}",
	"${zk3f}",
	"${zk1f}/zkdata",
	"${zk2f}/zkdata",
	"${zk3f}/zkdata" ] :
	ensure => directory,
}
# Build the myid file required for zookeepers
file { "${zk1f}/zkdata/myid":
	content => '1',
}
file { "${zk2f}/zkdata/myid":
	content => '2',
}
file { "${zk3f}/zkdata/myid":
	content => '3',
}
# Move the zookeeper-3.4.6.tar.gz to the zk main folder (FOR TESTING maybe used for prod if a download isn't possible.)
file { "${zkf}/zookeeper-3.4.6.tar.gz":
	ensure => present,
	mode => 0666,
	source => '/etc/puppet/environments/production/manifests/resources/zookeeper-3.4.6.tar.gz',
	before => Exec['unpack_file_zookeeper.tar.gz'],
}
# Use the -C (capital c) with a folder path to output to a specific folder.
# This needs repeating (for building multiple zookeepers on a single box)
exec {'unpack_file_zookeeper.tar.gz':
	path => "/bin:/sbin:/usr/bin:/usr/sbin",
	unless => 'test -f /usr/tmp/ent_search/zookeeper/zk1/bin/zkserver.sh',
	cwd => "${zkf}",
	command => "tar xvfz zookeeper-3.4.6.tar.gz -C zk1",
}
