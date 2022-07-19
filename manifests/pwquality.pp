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
class pam::pwquality (
  Integer[0] $difok                         = 5,
  Integer[0] $minlen                        = 9,
  Integer $dcredit                          = 1,
  Integer $ucredit                          = 1,
  Integer $lcredit                          = 1,
  Integer $ocredit                          = 1,
  Integer[0] $minclass                      = 0,
  Integer[0] $maxrepeat                     = 0,
  Integer[0] $maxclassrepeat                = 0,
  Integer[0] $maxsequence                   = 0,
  Integer[0, 1] $dictcheck                  = 1,
  Integer[0, 1] $gecoscheck                 = 0,
  Optional[Array[String[1]]] $badwords      = [],
  Optional[Stdlib::Absolutepath] $dictpath  = undef,
  Integer[0, 1] $usercheck                  = 1,
  Integer[0, 1] $usersubstr                 = 0,
  Integer[0, 1] $enforcing                  = 1,
  Integer[0] $retry                         = 3,
  Boolean $enforce_for_root                 = false,
  Boolean $local_users_only                 = false
  Stdlib::Absolutepath $pwquality_conf_file = '/etc/security/pwquality',
) {

  concat { $pwquality_conf_file:
    owner   => $pam_d_login_owner,
    group   => $pam_d_login_group,
    mode    => $pam_d_login_mode,
  }   
        
  # pwquality settings that are common to RHEL7, 8 and 9.
  concat::fragment {'rhelcommon':
    target  => pwquality_conf_file,
    order   => 10,
    content => template('pam/pwquality.conf.rhelcommon.erb'),
  }

  # pwquality settings that are unique to the major OS version.
  if ($facts['os']['release']['major'] in ['8', '9']) {
    concat::fragment {'rhel8stuff':
      target  => $pwquality_conf_file,
      order   => 20,
      content => template('pam/pwquality.conf.el8.erb'),
    }
  }

}
