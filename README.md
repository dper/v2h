v2h
===

A Vcard to hCard conversion script.


Dependencies
============

This script depends on the `vcard` gem.  This is easy to install.

    gem install vcard

See <https://rubygems.org/gems/vcard> for more.


Use
===

Put the target VCF file in the same directory as this script.  Rename the VCF file to `contacts.vcf`.  To run this script, just call it.  No arguments are needed (or useful).  The output file will be `contacts.html`.

    ./v2h.rb

If you're just browsing, see `example.contacts.vcf` and `example.contacts.html`.  The former, when used as input to this script, produces the latter.


References
==========

* <https://en.wikipedia.org/wiki/HCard>
* <http://www.microformats.org/wiki/hcard>
* <http://rubydoc.info/gems/vcard/0.2.12/frames>
