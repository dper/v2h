v2h
===

A Vcard to HTML conversion script.  The output is in something approximating hCard format.


Motivation
==========

I keep track of my contacts using OwnCloud, and I used to use GMail.  For both of these, the web interface is great for editing and viewing contacts, but sometimes you want a static file.  A static address book file is useful because you can access it without a net connection and it loads *very* quickly.  Both OwnCloud and GMail can be slow at times, particularly if you have hundreds of contacts in your address book.  This script takes a `vcf` file and produces an `html` file.  The resulting `html` file is styled by a CSS style sheet which you can modify to your own needs.


Dependencies
============

This script depends on the [vcard](https://rubygems.org/gems/vcard) gem.  This is easy to install.

    gem install vcard


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


License
=======

This project is under the MIT License.  Have fun with it!


Source
======

* Browse: <https://dperkins.org/git/gitlist/v2h.git/>.
* Clone: <https://dperkins.org/git/public/v2h.git/>.
* GitHub: <https://github.com/dper/v2h/>.


Contact
=======

If you want to contact the author, here are some ways.  Bug reports and improvements are always welcome.

* <https://microca.st/dper>
* <https://twitter.com/dpp0>
* <https://dperkins.org/tag/contact.html>