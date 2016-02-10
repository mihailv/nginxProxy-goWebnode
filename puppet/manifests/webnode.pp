# Base web node
exec { 'apt-update': command => '/usr/bin/apt-get update' }

# install vcs
class {'git': require => Exec['apt-update'] }

# install go bin
class{'golang::install': require => Class['git'] }

# install go web app
class{'golang::app': 
    app => "${::app}",
    path => "${::project_path}",
    source => "${::webnode_source}",
    webnode_port => "${::webnode_port}",
    require => Class["golang::install"]
}
