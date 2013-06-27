# virtual.pp
#
# People accounts of interest as virtual resources

class user::virtual {
    @user { "claudio":
        ensure  => "present",
        uid     => "1001",
        gid     => "1001",
        comment => "Claudio Walser",
        home    => "/home/claudio",
        shell   => "/bin/bash"
    }

    @user { "test":
        ensure  => "present",
        uid     => "1002",
        gid     => "1002",
        comment => "Test User",
        home    => "/home/test",
        shell   => "/bin/zsh"
    }

}