# Installs OLPC XS/XSX default configurations.

# install root
DESTDIR = /

$(DESTDIR):
	mkdir -p $(DESTDIR)

# For developers:

# rpm target directory
BUILDDIR = $(PWD)/build

# symbols
PKGNAME = xs-config
VERSION = $(shell git describe | sed 's/^v//' | sed 's/-/./g')
RELEASE = 1
ARCH = noarch

# NOTE: Release is hardcoded in the spec file to 1
NV = $(PKGNAME)-$(VERSION)
REL = 1

RPMBUILD = rpmbuild \
	--define "_topdir $(BUILDDIR)" \

SOURCES: Makefile
	mkdir -p $(BUILDDIR)/BUILD $(BUILDDIR)/RPMS \
	$(BUILDDIR)/SOURCES $(BUILDDIR)/SPECS $(BUILDDIR)/SRPMS
	mkdir -p $(NV)
	cp -p Makefile $(NV)
	rsync -ar altfiles/   $(NV)/altfiles
	rsync -ar scripts/    $(NV)/scripts
	tar czf $(BUILDDIR)/SOURCES/$(NV).tar.gz $(NV)
	rm -rf $(NV)

xs-config.spec: xs-config.spec.in
	sed -e 's:@VERSION@:$(VERSION):g' < $< > $@

.PHONY: xs-config.spec.in
	# This forces a rebuild of xs-config.spec.in

rpm: SOURCES xs-config.spec
	$(RPMBUILD) -ba --target $(ARCH) $(PKGNAME).spec
	rm -fr $(BUILDDIR)/BUILD/$(NV)
	rpmlint $(BUILDDIR)/RPMS/$(ARCH)/$(NV)-$(REL).$(ARCH).rpm

publish:
	scp $(BUILDDIR)/RPMS/$(ARCH)/$(NV)-$(REL).$(ARCH).rpm \
	    xs-dev.laptop.org:/xsrepos/testing/olpc/7/i386/
	scp $(BUILDDIR)/SRPMS/$(NV)-$(REL).src.rpm \
	    xs-dev.laptop.org:/xsrepos/testing/olpc/7/source/SRPMS/
	ssh xs-dev.laptop.org sudo createrepo /xsrepos/testing/olpc/7/i386

install: $(DESTDIR)

	install -D -d $(DESTDIR)/etc
	install -D -d $(DESTDIR)/etc/sysconfig
	install -D -d $(DESTDIR)/etc/sysconfig/olpc-scripts
	install -D -d $(DESTDIR)/var
	install -D -d $(DESTDIR)/var/named-xs
	install -D -d $(DESTDIR)/var/named-xs/data

	install -D altfiles/etc/named-xs.conf.in  $(DESTDIR)/etc
	install -D altfiles/etc/sysconfig/olpc-scripts/TURN_SQUID_OFF $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/TURN_SQUID_ON  $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/auxiliary_config $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/dhcpd.conf.1     $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/dhcpd.conf.1.aux $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/dhcpd.conf.2     $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/dhcpd.conf.2.aux $(DESTDIR)/etc/sysconfig/olpc-scripts/ 
	install -D altfiles/etc/sysconfig/olpc-scripts/dhcpd.conf.3     $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/dhcpd.conf.3.aux $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/dhcpd.conf.4     $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/dhcpd.conf.4.aux $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/dhcpd.conf.5     $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/dhcpd.conf.5.aux $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/dhcpd.conf.6     $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/dhcpd.conf.6.aux $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/dhcpd.conf.7     $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/dhcpd.conf.7.aux $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/dhcpd.conf.8     $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/dhcpd.conf.8.aux $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/domain_config    $(DESTDIR)/etc/sysconfig/olpc-scripts/

	install -D -d $(DESTDIR)/etc/sysconfig/olpc-scripts/domain_config.d
	install -D altfiles/etc/sysconfig/olpc-scripts/domain_config.d/dhcpd    $(DESTDIR)/etc/sysconfig/olpc-scripts/domain_config.d
	install -D altfiles/etc/sysconfig/olpc-scripts/domain_config.d/ejabberd $(DESTDIR)/etc/sysconfig/olpc-scripts/domain_config.d
	install -D altfiles/etc/sysconfig/olpc-scripts/domain_config.d/idmgr    $(DESTDIR)/etc/sysconfig/olpc-scripts/domain_config.d
	install -D altfiles/etc/sysconfig/olpc-scripts/domain_config.d/named    $(DESTDIR)/etc/sysconfig/olpc-scripts/domain_config.d
	install -D altfiles/etc/sysconfig/olpc-scripts/domain_config.d/squid    $(DESTDIR)/etc/sysconfig/olpc-scripts/domain_config.d

	install -D altfiles/etc/sysconfig/olpc-scripts/ifcfg-dummy0 $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/ifcfg-eth0   $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/ifcfg-eth0.auxiliary $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/ifcfg-eth1   $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/ifcfg-msh0   $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/ifcfg-msh1   $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/ifcfg-msh2   $(DESTDIR)/etc/sysconfig/olpc-scripts/ 
	install -D altfiles/etc/sysconfig/olpc-scripts/ifcfg-tun0   $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/ip6tables    $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/iptables.auxiliary  $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/iptables.principal  $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/iptables.principal.cache  $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/mkaccount    $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/network_config $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/etc/sysconfig/olpc-scripts/principal_config $(DESTDIR)/etc/sysconfig/olpc-scripts/
	install -D altfiles/var/named-xs/localdomain.zone         $(DESTDIR)/var/named-xs/
	install -D altfiles/var/named-xs/localhost.zone           $(DESTDIR)/var/named-xs/
	install -D altfiles/var/named-xs/named.broadcast          $(DESTDIR)/var/named-xs/ 
	install -D altfiles/var/named-xs/named.ip6.local          $(DESTDIR)/var/named-xs/
	install -D altfiles/var/named-xs/named.local              $(DESTDIR)/var/named-xs/
	install -D altfiles/var/named-xs/named.rfc1912.zones      $(DESTDIR)/var/named-xs/
	install -D altfiles/var/named-xs/named.root               $(DESTDIR)/var/named-xs/
	install -D altfiles/var/named-xs/named.root.hints         $(DESTDIR)/var/named-xs/
	install -D altfiles/var/named-xs/named.zero               $(DESTDIR)/var/named-xs/
	install -D altfiles/var/named-xs/school.external.zone.db  $(DESTDIR)/var/named-xs/
	install -D altfiles/var/named-xs/school.internal.zone.16.in-addr.db.in $(DESTDIR)/var/named-xs/
	install -D altfiles/var/named-xs/school.internal.zone.32.in-addr.db.in $(DESTDIR)/var/named-xs/
	install -D altfiles/var/named-xs/school.internal.zone.48.in-addr.db.in $(DESTDIR)/var/named-xs/
	install -D altfiles/var/named-xs/school.internal.zone.db               $(DESTDIR)/var/named-xs/
	install -D altfiles/var/named-xs/school.internal.zone.in-addr.db.in    $(DESTDIR)/var/named-xs/

	install -D -d $(DESTDIR)/etc/squid
	install -D altfiles/etc/squid/squid-xs.conf.in  $(DESTDIR)/etc/squid

	install -D -d $(DESTDIR)/etc/ejabberd
	install -D altfiles/etc/ejabberd/ejabberd.cfg.in  $(DESTDIR)/etc/ejabberd
	install -D altfiles/etc/ejabberd/ejabberd.pem     $(DESTDIR)/etc/ejabberd

	install -D altfiles/etc/resolv.conf.in  $(DESTDIR)/etc/
	install -D altfiles/etc/idmgr.conf.in  $(DESTDIR)/etc/

	# makefile-driven set
	install -D altfiles/etc/xs-config.make  $(DESTDIR)/etc/
	install -D altfiles/etc/syslog.conf.in  $(DESTDIR)/etc/
	install -D altfiles/etc/sysctl.conf.in  $(DESTDIR)/etc/
	install -D altfiles/etc/yum.conf.in     $(DESTDIR)/etc/
	install -D altfiles/etc/rssh.conf.in    $(DESTDIR)/etc/
	install -D altfiles/etc/motd.in         $(DESTDIR)/etc/

	install -D -d $(DESTDIR)/etc/ssh
	install -D altfiles/etc/ssh/sshd_config.in $(DESTDIR)/etc/ssh

	install -D altfiles/etc/sysconfig/dhcpd.in $(DESTDIR)/etc/sysconfig
	install -D altfiles/etc/sysconfig/init.in  $(DESTDIR)/etc/sysconfig
	install -D altfiles/etc/sysconfig/named.in $(DESTDIR)/etc/sysconfig
	install -D altfiles/etc/sysconfig/squid.in $(DESTDIR)/etc/sysconfig
	install -D altfiles/etc/sysconfig/iptables-config.in $(DESTDIR)/etc/sysconfig

	# conf.d-style conffiles
	install -D -d $(DESTDIR)/etc/httpd/conf.d
	install -D altfiles/etc/httpd/conf.d/mime_olpc.conf  $(DESTDIR)/etc/httpd/conf.d

	install -D -d $(DESTDIR)/etc/yum.repos.olpc.d
	install -D altfiles/etc/yum.repos.olpc.d/testing.repo $(DESTDIR)/etc/yum.repos.olpc.d
	install -D altfiles/etc/yum.repos.olpc.d/stable.repo  $(DESTDIR)/etc/yum.repos.olpc.d

	# conf.d-style conffiles that are actually executable scripts...
	install -D -d $(DESTDIR)/etc/udev/rules.d
	install -D altfiles/etc/udev/rules.d/10-olpcmesh.rules  $(DESTDIR)/etc/udev/rules.d

	install -D -d $(DESTDIR)/etc/init.d
	install -D altfiles/etc/init.d/olpc-network-config  $(DESTDIR)/etc/init.d
	install -D altfiles/etc/init.d/olpc-mesh-config  $(DESTDIR)/etc/init.d

	install -D -d $(DESTDIR)/etc/usbmount/mount.d
	install -D altfiles/etc/usbmount/mount.d/01_beep_on_mount  $(DESTDIR)/etc/usbmount/mount.d
	install -D altfiles/etc/usbmount/mount.d/99_beep_when_done $(DESTDIR)/etc/usbmount/mount.d

	install -D --mode 750 -d $(DESTDIR)/etc/sudoers.d
	install -D --mode 440 altfiles/etc/sudoers.d/00-base  $(DESTDIR)/etc/sudoers.d

	# scripts
	install -D -d $(DESTDIR)/usr/bin
	install -D scripts/xs-commitchanged $(DESTDIR)/usr/bin
	install -D scripts/cat-parts $(DESTDIR)/usr/bin

	# libertas modules and fw ## REMOVE in F9
	install -D -d $(DESTDIR)/lib/firmware
	install -D -d $(DESTDIR)/lib/modules/2.6.23.1-21.fc7/kernel/drivers/net/wireless/libertas
	install -D altfiles/lib/firmware/LICENSE-usb8388.bin $(DESTDIR)/lib/firmware
	install -D altfiles/lib/firmware/usb8388.bin         $(DESTDIR)/lib/firmware
	install -D altfiles/lib/modules/2.6.23.1-21.fc7/kernel/drivers/net/wireless/libertas/libertas.ko $(DESTDIR)/lib/modules/2.6.23.1-21.fc7/kernel/drivers/net/wireless/libertas
	install -D altfiles/lib/modules/2.6.23.1-21.fc7/kernel/drivers/net/wireless/libertas/usb8xxx.ko $(DESTDIR)/lib/modules/2.6.23.1-21.fc7/kernel/drivers/net/wireless/libertas

