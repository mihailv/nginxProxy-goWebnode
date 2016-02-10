class nginx ($webnode_ips = undef){
    
    # install nginx
    package { 'nginx':
        ensure => installed
    }
    
    service { 'nginx':
        ensure => running,
        enable => true,
        require => Package['nginx']
    }
    
    # use as proxy
    if $webnode_ips != undef {
    
        file{'/etc/nginx/sites-available/default':
            content => template("nginx/proxy.erb"),
            notify  => Service['nginx'],
            require => Package['nginx']
        }
    }
}
