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
  Integer[0] $difok,
  Integer[0] $minlen,
  Integer $dcredit,
  Integer $ucredit,
  Integer $lcredit,
  Integer $ocredit,
  Integer[0] $minclass,
  Integer[0] $maxrepeat,
  Integer[0] $maxclassrepeat,
  Integer[0] $maxsequence,
  Integer[0] $dictcheck,
  Integer[0, 1] $gecoscheck = 0,
  Optional[Array[String[1]]] $badwords = [],
  Optional[Stdlib::Absolutepath] $dictpath = undef,
) {

  file { '/etc/security/pwquality.conf':
    ensure  => file,
    content => template('pam/pwquality.conf.el7.erb'),
    owner   => $pam_d_login_owner,
    group   => $pam_d_login_group,
    mode    => $pam_d_login_mode,
  }

}
