# What Files are installed
FOLDERS= _config _helpers bin _completions
# Prefix for installation.

PREFIX=$(ENV)/usr
# Where should the library files be placed?
DESTDIR=$(PREFIX)/share/notes
BINDIR=$(PREFIX)/bin

BASH_COMPLETION=_completions/c.bash
BASH_COMPLETION_DEST=$(ENV)/etc/bash_completion.d

.PHONY: install
install:
	mkdir -p $(DESTDIR)
	mkdir -p $(BINDIR)
	cp -dr -t $(DESTDIR)/ $(FOLDERS) 
	ln -s /usr/share/notes/bin/notes $(BINDIR)/notes
	mkdir -p $(BASH_COMPLETION_DEST) 
	cp $(BASH_COMPLETION) $(BASH_COMPLETION_DEST)/notes
	
