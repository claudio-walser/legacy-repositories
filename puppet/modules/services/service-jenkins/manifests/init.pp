class service-jenkins {

    class { '::service-java::runtime': } ->
    class { '::jenkins': }

}
