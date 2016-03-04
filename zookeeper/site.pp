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
file { "${zk1f}/zkdata/myid":
	content => '1',
}
file { "${zk2f}/zkdata/myid":
	content => '2',
}
file { "${zk3f}/zkdata/myid":
	content => '3',
}
file { "${zkf}/zookeeper-3.4.6.tar.gz":
	ensure => present,
	mode => 0666,
	source => '/etc/puppet/environments/production/manifests/resources/zookeeper-3.4.6.tar.gz',
	before => Exec['unpack_file_zookeeper.tar.gz'],
}
exec {'unpack_file_zookeeper.tar.gz':
	unless => 'test -f /usr/tmp/ent_search/zookeeper/zk1/bin/zkserver.sh',
	cwd => "${zkf}",
	command => 'tar xvfz zookeeper-3.4.6.tar.gz'
}