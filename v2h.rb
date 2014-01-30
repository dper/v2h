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

	telephones.each do |tel|
		location = tel.location[0]
		html += '<span class="' + location + '">' + tel + '</span>' + "\n"
	end

	html += '</div>' + "\n"
	return html
end

def write_url urls
	if urls.size == 0
		return ''
	end

	html = '<div class="url">' + "\n"

	urls.each do |url|
		link = url.uri
		html += '<span><a href="' + link + '">' + link + '</a></span>'
	end

	html += '</div>' + "\n"
	return html
end

# Converts a single Vcard to HTML.
def vcard_to_html card
	html = '<div class="vcard">' + "\n"
	html += write_name card.name
	html += write_telephone card.telephones
	html += write_url card.urls



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
