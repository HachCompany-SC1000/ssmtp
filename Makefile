# Generated automatically from Makefile.in by configure.


srcdir= .
prefix=/usr/local
exec_prefix=${prefix}
libexecdir=${exec_prefix}/libexec
bindir=$(prefix)/sbin
mandir=$(prefix)/man/man8

LN_S=ln -s
CC=sh3-linux-gcc

etcdir=${prefix}/etc
SSMTPCONFDIR=$(etcdir)/ssmtp
# (End of relocation section)

# Configuration files
CONFIGURATION_FILE=$(SSMTPCONFDIR)/ssmtp.conf
REVALIASES_FILE=$(SSMTPCONFDIR)/revaliases

INSTALLED_CONFIGURATION_FILE=$(CONFIGURATION_FILE)
INSTALLED_REVALIASES_FILE=$(REVALIASES_FILE)

# Programs
GEN_CONFIG=$(srcdir)/generate_config

SRCS=ssmtp.c arpadate.c base64.c xgethostname.c  md5auth/md5c.c md5auth/hmac_md5.c

OBJS=$(SRCS:.c=.o)

INSTALL=/usr/bin/install -c

EXTRADEFS=\
-DSSMTPCONFDIR=\"$(SSMTPCONFDIR)\" \
-DCONFIGURATION_FILE=\"$(CONFIGURATION_FILE)\" \
-DREVALIASES_FILE=\"$(REVALIASES_FILE)\" \


CFLAGS= -DSTDC_HEADERS=1 -DHAVE_LIMITS_H=1 -DHAVE_STRINGS_H=1 -DHAVE_SYSLOG_H=1 -DHAVE_UNISTD_H=1 -DHAVE_LIBNSL=1 -DRETSIGTYPE=void -DHAVE_VPRINTF=1 -DHAVE_GETHOSTNAME=1 -DHAVE_SOCKET=1 -DHAVE_STRDUP=1 -DHAVE_STRSTR=1 -DREWRITE_DOMAIN=1 -DMD5AUTH=1  $(EXTRADEFS) -g -O2 -Wall

#Plugin with static ssl lib
plugin: CFLAGS += -DHAVE_SSL=1 -I./../openssl/include -ldl

#Plugin with shared ssl lib
pluginS: CFLAGS += -DHAVE_SSL=1 -I./../openssl/include


.PHONY: all

all:	ssmtp

%.dvi: %.tex
	latex $<

.PHONY: install
install: ssmtp $(GEN_CONFIG)
	$(INSTALL) -d -m 755 $(bindir)
	$(INSTALL) -s -m 755 ssmtp $(bindir)/ssmtp
	$(INSTALL) -d -m 755 $(mandir)
	$(INSTALL) -m 644 $(srcdir)/ssmtp.8 $(mandir)/ssmtp.8
	$(INSTALL) -d -m 755 $(SSMTPCONFDIR)
	$(INSTALL) -m 644 $(srcdir)/revaliases $(INSTALLED_REVALIASES_FILE)
	$(GEN_CONFIG) $(INSTALLED_CONFIGURATION_FILE)


.PHONY: install-sendmail
install-sendmail: install
	$(RM) $(bindir)/sendmail
	$(LN_S) ssmtp $(bindir)/sendmail
	$(INSTALL) -d -m 755 $(libexecdir)
	$(RM) $(libexecdir)/sendmail
	$(LN_S) sendmail /lib/sendmail
	$(RM) $(mandir)/sendmail.8
	$(LN_S) ssmtp.8 $(mandir)/sendmail.8

.PHONY: uninstall
uninstall:
	$(RM) $(bindir)/ssmtp
	$(RM) $(mandir)/ssmtp.8
	$(RM) $(CONFIGURATION_FILE) $(REVALIASES_FILE)
	$(RM) -r $(SSMTPCONFDIR)

.PHONY: uninstall-sendmail
uninstall-sendmail: uninstall
	$(RM)  $(bindir)/sendmail /lib/sendmail
	$(RM)  $(mandir)/sendmail.8

# Binaries:
ssmtp: 	$(OBJS)
#Target version without SSL
	$(CC) -o ssmtp $(OBJS) -lnsl  $(CFLAGS)
	$(RM) *.o md5auth/*.o core

plugin: $(OBJS)
#Plugin version with SSL Static Lib
	$(CC) -o ssmtp_plugin $(OBJS) -static -L./../openssl -lnsl -lssl -lcrypto $(CFLAGS)
	$(RM) *.o md5auth/*.o core

pluginS: $(OBJS)
#Plugin version with SSL Shared Lib
	$(CC) -o ssmtp_plugin_shared $(OBJS) -lnsl -lssl -lcrypto $(CFLAGS3)
	$(RM) *.o md5auth/*.o core


.PHONY: clean
clean:
	$(RM) ssmtp ssmtp_plugin* *.o md5auth/*.o core

.PHONY: distclean
distclean: clean docclean
	$(RM) config.* Makefile

.PHONY: docclean
docclean:
	$(RM) *.dvi *.log *.aux
