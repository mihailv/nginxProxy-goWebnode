class git(){
    
    # ensure git package installed
    package {'git': 
        ensure => installed
    }

}
