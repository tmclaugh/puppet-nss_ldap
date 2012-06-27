
class nss_ldap ($ldap_nss_uri,
				$ldap_base,
				$ldap_binddn,
				$ldap_bindpw,
				$ldap_base_users,
				$ldap_base_groups)
{
	package { "nss_ldap" :
		ensure => installed,
	}

	file { "/etc/ldap.conf" :
		owner => "root",
		group => "root",
		mode => '0644',
		content => template("nss_ldap/ldap.conf.erb"),
		require => [Class["ldap"], Package["nss_ldap"]],
	}

	# XXX: We should probably go back to running sed on
	# nsswitch.conf since it's more portable than below.
	exec {"authconfig_enableldap" :
		# XXX: restart nscd on our own.
		command => "authconfig --nostart --enableldap --update",
		unless => "perl -ne 'BEGIN { @p = (qr/^passwd:.*ldap/, qr/^shadow:.*ldap/, qr/^group:.*ldap/); } for \$p (@p) { \$p{\$p}++ if /\$p/ }; END { exit (@p != keys %p) }' /etc/nsswitch.conf",
		require => File["/etc/ldap.conf"]
	}
}
