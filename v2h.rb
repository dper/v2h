#!/usr/bin/ruby

require "vcard"
include Vcard

$filename = "contacts.vcf"

def write_name name
	html = '<span class="fn">' + name.fullname + '</span>' + "\n"
	return html
end

def write_telephone telephones
	if telephones.size == 0
		return ''
	end
	
	html = '<div class="tel">' + "\n"

	card.telephones.each do |tel|
		html += '<div class="tel">' + tel + '</div>' + "\n"
	end

	html += '</div>' + "\n"
	return html
end

# Converts a single Vcard to HTML.
def vcard_to_html card
	html = '<div class="vcard">' + "\n"
	html += write_name card.name
	html += write_telephone card.telephones


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
