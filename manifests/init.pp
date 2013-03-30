
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
		require => Package["nss_ldap"],
	}
}
