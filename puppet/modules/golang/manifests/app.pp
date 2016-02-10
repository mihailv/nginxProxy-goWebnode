class golang::app($app, $path, $source, $webnode_port = undef){
    
    # golang directory structure
    $paths = [ "$path", "$path/bin", "$path/src", "$path/pkg"]
    file { $paths:
        ensure => 'directory'
    }
    
    # set $GOPATH in .profile   
    exec { 'gopath':
        path => [ '/bin/', '/usr/bin/', '/usr/local/bin/' ],
        command => "/bin/echo 'export GOPATH=$path' >> /root/.profile",
        unless  => "/bin/grep -q GOPATH /root/.profile ; /usr/bin/test $? -eq 0",
        require => File[$paths]
    }
    
    # install $app bin by go get    
    exec { 'install':
        path => [ '/bin/', '/usr/bin/', '/usr/local/bin/' ],
        command => "bash -c 'source /root/.profile && go get $source'",
        require => Exec["gopath"]
    }
    
    # isntall init if web
    if $webnode_port != undef {
        file{"/etc/init.d/$app":
            content => template("golang/init_script.erb"),
            mode   => 0777,
            require => Exec['install']
        }
        service { "$app":
            ensure => 'running',
            require => File["/etc/init.d/$app"]
        }
    }
    
    
}
