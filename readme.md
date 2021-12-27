### todo

#### lxc-host

/etc/resolv.conf was empty after container restart
thus install did not continue on its own

#### wp deploy

#### apache

harden /etc/apache2/conf-enable/security.conf
ServerTokens Minimal
ServerSignature Off

harden default vhost with
Header set Content-Security-Policy: "frame-ancestors 'self';"
Header set X-Frame-Options: "sameorigin"