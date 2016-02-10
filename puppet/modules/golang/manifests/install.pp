class golang::install($via_packman = 'false', $version = '1.5.3'){
    
    # Installer for go PL
    if $via_packman == 'true'{
    
        # provided via package manager
        package { 'golang': ensure => installed }
        
    }else { 
    
        # download via http from golang.org
        exec { 'download':
            command => "/usr/bin/wget --no-check-certificate -O /usr/local/src/go$version.linux-amd64.tar.gz http://golang.org/dl/go$version.linux-amd64.tar.gz",
            creates => "/usr/local/src/go$version.linux-amd64.tar.gz"
        }
        
        # unarchive
        exec { 'unarchive':
            command => "/bin/tar -C /usr/local -xzf /usr/local/src/go$version.linux-amd64.tar.gz",
            require => Exec["download"]
        }
        
        # create link
        exec { 'link_go':
                command => "/bin/ln -s /usr/local/go/bin/* /bin",
                creates => '/bin/go',
                require => Exec['unarchive']
        }
    }   
}
