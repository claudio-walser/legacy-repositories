class service-icinga::target {
  include ::platform_services_firewall::nrpe

  Icinga::Service {
    use => 'generic-service',
    use_nrpe => true,
  }

  class{'::icinga::target':
    use => 'linux-server',
  }
  class{'::icinga::nrpe':
    nrpe_allowed_hosts => "127.0.0.1,10.0.0.0/8",
  }
  icinga::service{
    'ping':
      service_description => 'Ping',
      check_command => 'check_ping!200.0,5%!400.0,10%',
      use_nrpe => false;
    'cpu':
      service_description => 'CPU Usage',
      check_command => 'check_cpu';
    'memory':
      service_description => 'Memory Usage',
      check_command => 'check_memory';
    'load':
      service_description => 'Load',
      check_command => 'check_load',
      nrpe_args => '10.0,8.0,6.0\!20.0,15.0,10.0';
    'total-processes':
      service_description => 'Total Processes',
      check_command => 'check_procs',
      nrpe_args => '150\!300\!RSZDT';
    'root-partition':
      service_description => 'Root Partition',
      check_command => 'check_disk_all',
      nrpe_args => '10%\!5%';
    'swap':
      service_description => 'Swap',
      check_command => 'check_swap',
      nrpe_args => '10\!5';
  }
}