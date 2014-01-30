#!/usr/bin/ruby

require "vcard"
include Vcard

$filename = "contacts.vcf"

# Converts a single Vcard to HTML.
def vcard_to_html card
	puts card.name.fullname
end

# Converts a VCF file to HTML.
# The file must consist of one or more Vcards.
def vcf_to_html
	s = File.read($filename)
	cards = Vcard::Vcard.decode(s)

	cards.each do |card|
		vcard_to_html card
	end
end

vcf_to_html
