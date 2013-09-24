class service-jenkins {
    
    #wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
    #deb http://pkg.jenkins-ci.org/debian binary/
    #sudo apt-get update
    #sudo apt-get install jenkins



    #include java

    # apt source repo for jenkins
    #apt::source { 'jenkins-debian':
    #    location    => "http://pkg.jenkins-ci.org/debian",
    #    release     => "binary/",
    #    repos       => "",
    #    include_src => false,
    #} ->
    #package { "":

    #}

    # install git
    #package { "jenkins":
    #    ensure => "installed"
    #} ->

    #service { "jenkins":
    #    ensure => running
    #}

}
