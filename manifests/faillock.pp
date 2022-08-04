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
  Stdlib::Absolutepath $dir,
  Boolean $faillock_audit,
  Boolean $silent,
  Boolean $no_log_info,
  Boolean $local_users_only,
  Integer[0] $deny,
  Integer[0] $fail_interval,
  Integer[0] $unlock_time,
  Boolean $even_deny_root,
  Integer[0] $root_unlock_time,
  Optional[String[1]] $admin_group,
  Stdlib::Absolutepath $faillock_conf_file,
) {

  # For now, only RHEL8 and newer are supported.
  if ($facts['os']['release']['major'] in ['7', '8', '9']) {
    concat { $faillock_conf_file:
      owner   => $pam_d_login_owner,
      group   => $pam_d_login_group,
      mode    => $pam_d_login_mode,
    }   
        
    concat::fragment {'faillock_rhel':
      target  => $faillock_conf_file,
      order   => 20,
      content => template('pam/faillock.conf.erb'),
    }
  }

}
