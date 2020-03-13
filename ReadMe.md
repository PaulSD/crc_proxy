# HTTP forward proxy for CodeReady Containers VM

The RedHat CodeReady Containers VM (CRC) provides a minimal OpenShift cluster for experimentation on
a local system.  It currently uses NetworkManager and dnsmasq on the host system to enable access to
services running in OpenShift.  If the host system is not running NetworkManager then it is trivial
to disable the automated network configuration and replace it with manual configuration or custom
scripts.  However, if the host system is not running dnsmasq then it may not be trivial to
replace/replicate the automated DNS configuration.  But, since an HTTP forward proxy will perform
DNS lookups on behalf of clients, the need for DNS configuration on the host system can be avoided
entirely by running an HTTP forward proxy inside of OpenShift and using the proxy instead of local
DNS configuration to direct traffic to OpenShift as needed.

Therefore, this OpenShift Template deploys an HTTP forward proxy into OpenShift, eliminating the
requirement to run dnsmasq or implement DNS overrides on a CRC host system,

### Install:
```
oc new-project crc-proxy
oc new-app -f https://raw.githubusercontent.com/PaulSD/crc_proxy/master/openshift/templates/crc_proxy.json
```

### Usage:
Configure your browser to use `192.168.130.11:8080` as the HTTP/HTTPS proxy for domains that end
with `.testing`.  For standard browsers (Chrome/Firefox), this is easiest to accomplish using an
automatic configuration file (enter `file:///home/user/.proxy.pac` in the URL field in the browser's
proxy settings page):
```
cat <<END >~/.proxy.pac
function FindProxyForURL(url, host) {
  if (dnsDomainIs(host, ".testing")) { return "PROXY 192.168.130.11:8080"; }
  return "DIRECT";
}
END
```
For command line browsers or scripts, this is usually accomplished by setting environment variables
before accessing relevant URLs (and unsetting them before accessing irrelevant URLs if necessary):
```
HTTP_PROXY='192.168.130.11:8080'
HTTPS_PROXY='192.168.130.11:8080'
```

### Uninstall:
```
oc delete project crc-proxy
```
