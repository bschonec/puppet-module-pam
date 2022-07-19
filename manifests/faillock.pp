# @summary This module manages PAM.
#
# @example Declaring the class
#   include pam
#
# @param allowed_users
#   String, Array or Hash of strings and/or arrays to configure users and
#   origins in access.conf. The default allows the root user/group from origin
#   'ALL'.
#
# @param login_pam_access
#   Control module to be used for pam_access.so for login. Valid values are
#   'required', 'requisite', 'sufficient', 'optional' and 'absent'.
#
class pam::faillock (
  Stdlib::Absolutepath $dir = '/var/run/faillock',
  Boolean $audit            = false,
  Boolean $silent           = false,
  Boolean $no_log_info      = false,
  Boolean $local_users_only = false,
  Integer[0] $deny          = 3,
  Integer[0] $fail_interval = 900,
  Integer[0] $unlock_time   = 600,
  Boolean $even_deny_root   = false,
  Integer[0] $root_unlock_time = 900,
  Optional[String] $admin_group = undef,
  Stdlib::Absolutepath $faillock_conf_file = '/etc/security/faillock.conf',
) {

  # For now, only RHEL8 and newer are supported.
  if ($facts['os']['release']['major'] in ['8', '9']) {
    concat { $pwquality_conf_file:
      owner   => $pam_d_login_owner,
      group   => $pam_d_login_group,
      mode    => $pam_d_login_mode,
    }   
        
    concat::fragment {'rhel8stuff':
      target  => $pwquality_conf_file,
      order   => 20,
      content => template('pam/faillock.conf.erb'),
    }
  }

}
