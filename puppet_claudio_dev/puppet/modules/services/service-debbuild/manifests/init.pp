class service-debbuild {
	package {[
		"debootstrap",
		"live-build"
	]:
		ensure => "installed"
	}
}

