# This script will setup multiple zookeepers on a single server.
$esf = "/usr/tmp/ent_search"
$zkf = "${esf}/zookeeper"
$zk1f = "${zkf}/zk1"
$zk2f = "${zkf}/zk2"
$zk3f = "${zkf}/zk3"

# Create the parent folders
file {[ "${esf}",
		"${zkf}"]:
	ensure => directory,
}
# Move the zookeeper-3.4.6.tar.gz to the zk main folder (FOR TESTING maybe used for prod if a download isn't possible.)
file { "${zkf}/zookeeper-3.4.6.tar.gz":
	owner => "sean",
	group => "sean",
	mode => 0666,
	ensure => present,
	source => "/etc/puppet/environments/production/manifests/resources/zookeeper-3.4.6.tar.gz",
	notify => Exec["unpack_file_zookeeper.tar.gz"],
}
# Use the -C (capital c) with a folder path to output to a specific folder.
# This needs repeating (for building multiple zookeepers on a single box)
exec {'unpack_file_zookeeper.tar.gz':
	path => "/bin:/sbin:/usr/bin:/usr/sbin",
	command => "tar xvfz zookeeper-3.4.6.tar.gz",
	unless => 'test -f /usr/tmp/ent_search/zookeeper/zk1/bin/zkserver.sh',
	cwd => "${zkf}",
	refreshonly => true,
}
/*
exec { 'rename_zookeeper_zk1':
	path => "/bin:/sbin:/usr/bin:/usr/sbin",
	command => "cp ${zkf}/zookeeper-3.4.6 ${zkf}/zk1",
	creates => "${zkf}/zk1",
}
exec { 'rename_zookeeper_zk2':
	path => "/bin:/sbin:/usr/bin:/usr/sbin",
	command => "cp ${zkf}/zookeeper-3.4.6 ${zkf}/zk2",
	creates => "${zkf}/zk2",
}
exec { 'rename_zookeeper_zk3':
	path => "/bin:/sbin:/usr/bin:/usr/sbin",
	command => "cp ${zkf}/zookeeper-3.4.6 ${zkf}/zk3",
	creates => "${zkf}/zk3",
}
file {[ "${zk1f}/zkdata",
	"${zk2f}/zkdata",
	"${zk3f}/zkdata"]:
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
*/