class service-redmine::backup {

    class{ '::component-backup':
    	keepBackups => 5, # Keep last "${component-backup::keepBackups}" backups

    	files => [{
    		paths => [
    			'/opt/redmine/public/plugin_assets',
    			'/opt/redmine/public/themes',
    			'/opt/redmine/plugins',
    			'/opt/redmine/db/migrate'
    		],
    		destination => 'redmine-2.3.3',
    		cron => {
				name        => 'backup-redmine-files', # (namevar) The symbolic name of the cron job.  This name is 
				ensure      => 'present', # The basic property that the resource should be...
				hour        => '', # The hour at which to run the cron job. Optional; 
				minute      => '', # The minute at which to run the cron job...
				month       => '', # The month of the year.  Optional; if specified...
				monthday    => '', # The day of the month on which to run the...
				weekday     => '' # The weekday on which to run the command...   			
    		}
    	}],
    	
    	databases => [{
    		host => 'localhost',
    		user => 'redmine',
    		pass => 'redmine',
    		table => 'redmine',
    		destination => 'redmine-2.3.3.sql',
    		cron => {
				name        => 'backup-redmine-database', # (namevar) The symbolic name of the cron job.  This name is 
				ensure      => 'present', # The basic property that the resource should be...
				hour        => '', # The hour at which to run the cron job. Optional; 
				minute      => '', # The minute at which to run the cron job...
				month       => '', # The month of the year.  Optional; if specified...
				monthday    => '', # The day of the month on which to run the...
				weekday		=> '' # The weekday on which to run the command...
    		}
    	}]
    }
    
}
