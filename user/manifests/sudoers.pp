#sudoers.pp in the user module
#--------------------------------------

# sudoers.pp
# Realize the members of the Unix team and include any contractors

class user::sudoers inherits user::virtual {
    # Realize our team members
    realize(
        User["claudio"]
    )
}