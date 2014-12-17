Puppet module to install gitlab via omnibus packages - debian only right now

#### Usage

Gitlab and Gitlab-Ci on a single node, where you have an additional dns entry for ci.gitlab.example.com, pointing to the same machine.

    class {'::gitlab':
        data_dir => '/var/opt/gitlab/git-data/',
        backup_dir => '/var/opt/gitlab/backups/',
        url => 'gitlab.example.com'
    }
    class {'::gitlab::ci':
        url => 'ci.gitlab.example.com'
    }

Gitlab and Gitlab-Ci on separate nodes. gitlab::ci gets into single mode as soon as you pass the gitlab_server_urls param with some values.

On gitlab Node

    class {'::gitlab':
        data_dir => '/var/opt/gitlab/git-data/',
        backup_dir => '/var/opt/gitlab/backups/',
        url => 'gitlab.example.com'
    }

On gitlab-ci Node

    class {'::gitlab::ci':
        url => 'gitlab-ci.example.com',
        gitlab_server_urls => ['http://gitlab.example.com']
    }

#### Create Backup
    sudo gitlab-rake gitlab:backup:create

#### Restore Backup
    sudo gitlab-rake gitlab:backup:restore
