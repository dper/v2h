#!/usr/bin/ruby

require "vcard"
include Vcard

# The input contact file.
$input = 'contacts.vcf'
$output = 'contacts.html'

# Returns a string of HTML with the contact's name.
def write_name name
	html = '<div class="n">'
	html += '<span class="fn">' + name.fullname + '</span>' + "\n"
	html += '</div>'
	return html
end

# Returns a string of HTML with the contact's phone numbers.
def write_telephone telephones
	if telephones.empty?
		return ''
	end
	
	html = '<div class="tel">' + "\n"

	telephones.each do |tel|
		location = tel.location.first
		if location
			html += '<span class="' + location + '">' + tel + '</span>' + "\n"
		else
			html += '<span>' + tel + '</span>' + "\n"
		end
	end

	html += '</div>' + "\n"
	return html
end

# Returns a string of HTML with the contact's email addresses.
def write_email emails
	if emails.empty?
		return ''
	end

	html = '<div class="email">' + "\n"

	emails.each do |email|
		location = email.location.first
		if location
			html += '<span class="' + location + '">' + email + '</span>' + "\n"
		else
			html += '<span>' + email + '</span>' + "\n"
		end
	end

	html += '</div>' + "\n"
	return html
end

# Returns a string of HTML with the contact's URLs.
def write_url urls
	if urls.empty?
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

# Returns a string of HTML with the contact's addresses.
def write_address addresses
	if addresses.empty?
		return ''
	end

	html = '<div class="addresses">' + "\n"

	addresses.each do |address|
		html += '<div class="adr">'

		#TODO Handle addresses better.
		html += address.street

		html += '</div>' + "\n"
	end

	html += '</div>' + "\n"
	return html
end

# Returns a string of HTML with the contact's categories.
def write_category categories
	if categories.empty?
		return ''
	end

	html = '<div class="categories">' + "\n"

	categories.each do |category|
		html += '<span class="category">' + category + '</span>' + "\n"
	end

	html += '</div>' + "\n"
	return html
end

# Converts a single Vcard to HTML.
def vcard_to_html card
	html = '<div class="vcard">' + "\n"
	html += write_name card.name
	html += write_telephone card.telephones
	html += write_email card.emails
	html += write_url card.urls
	html += write_address card.addresses
	html += write_category card.categories
	html += '</div>' + "\n"
	return html
end

# Takes a list of Vcards and makes HTML for them.
def write_html cards
	html = '<html>' + "\n"
	html += '<head>' + "\n"
	html += '<link rel="stylesheet" href="./contacts.css" type="text/css" />' + "\n"
	html += '<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />' + "\n"
	html += '</head>' + "\n"
	html += '<body>' + "\n"
	html += '<h1>Contacts</h1>' + "\n"

	cards.each do |card|
		html += vcard_to_html card
	end

	html += '</body>' + "\n"
	html += '</html>' + "\n"
	return html
end

# Converts a VCF file to HTML.
# The file must consist of one or more Vcards.
def vcf_to_html
	s = File.read($input)
	cards = Vcard::Vcard.decode(s)
	html = write_html cards

	open($output, 'w') do |file|
		file.puts html
	end
end

vcf_to_html
