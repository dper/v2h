#!/usr/bin/ruby

require "vcard"
include Vcard

$filename = "contacts.vcf"

# Converts a single Vcard to HTML.
def vcard_to_html card
	html = '<div class="vcard">' + "\n"

	html += '<span class="fn">' + card.name.fullname + '</span>' + "\n"

	if card.telephones.size > 0
		card.telephones.each do |tel|
			html += '<div class="tel">' + tel + '</div>' + "\n"
		end
	end

	if card.emails.size > 0
		card.emails.each do |email|
			html += '<a class="email" href="' + email + '">' + email + '</a>' + "\n"
		end
	end

	html += '</div>' + "\n"
	return html
end

# Converts a VCF file to HTML.
# The file must consist of one or more Vcards.
def vcf_to_html
	s = File.read($filename)
	cards = Vcard::Vcard.decode(s)

	html = '<html>' + "\n"
	html += '<body>' + "\n"

	cards.each do |card|
		html += vcard_to_html card
	end

	html += '</body>' + "\n"
	html += '</html>' + "\n"

	#TODO Write this to a file.
	puts html
end

vcf_to_html
