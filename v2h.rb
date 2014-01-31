#!/usr/bin/ruby
# coding: utf-8
#
# == NAME
# v2h.rb
#
# == USAGE
# ./v2h.rb
#
# == DESCRIPTION
# Takes a VCF file containing one or more Vcards and makes an HTML file of it.
# The HTML is hCard 1.0 formatted.


require "vcard"
include Vcard

# The input contact file.
$input = 'contacts.vcf'
$output = 'contacts.html'

# Returns a string of HTML with the contact's name.
def write_name name
	html = '<div class="n">' + "\n"
	html += '<span class="fn">' + name.fullname + '</span>' + "\n"
	html += '</div>' + "\n"
	return html
end

# Returns a string of HTML with the contact's phone numbers.
def write_telephone telephones
	if telephones.empty?
		return ''
	end
	
	html = '<div class="telephones">' + "\n"

	telephones.each do |tel|
		location = tel.location.first
		if location
			html += '<span class="tel ' + location + '">' + tel + '</span>' + "\n"
		else
			html += '<span class="tel">' + tel + '</span>' + "\n"
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

	html = '<div class="emails">' + "\n"

	emails.each do |email|
		location = email.location.first
		if location
			html += '<span class="email ' + location + '">' + email + '</span>' + "\n"
		else
			html += '<span class="email">' + email + '</span>' + "\n"
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

	html = '<div class="urls">' + "\n"

	urls.each do |url|
		link = url.uri
		html += '<span><a class="url" href="' + link + '">' + link + '</a></span>' + "\n"
	end

	html += '</div>' + "\n"
	return html
end

# Returns a string of HTML with the contact's birthday.
def write_birthday birthday
	unless birthday
		return ''
	end

	html = '<div class="bday">'
	html += birthday.strftime("%B %-d, %Y")
	html += '</div>' + "\n"
	return html
end

# Returns true iff the address is formatted as lat/long coordinates.
# Proper coordinates are decimal numbers separated by a comma.
def is_gps_address? address
	# Blank spaces are ignored.
	address = address.gsub(' ', '')
	address = address.gsub('　', '')

	float_pattern = '(-)?[[:digit:]]+(\.)?+[[:digit:]]+'
	gps_pattern = float_pattern + ',' + float_pattern
	return (address.match gps_pattern) != nil
end

# Returns true iff the address is a U.S.-style street address.
# The country need not be a U.S. country if the formatting is the same.
def is_multiline_address? address
	count = 0

	unless address.country.empty? then count += 1 end
	unless address.postalcode.empty? then count += 1 end
	unless address.region.empty? then count += 1 end
	unless address.locality.empty? then count += 1 end
	unless address.street.empty? then count += 1 end

	return count > 1
end

# Returns a string of HTML for a multiline street address.
# Address formatting is U.S. standard.
# If fields are missing, they will be skipped.
# This can lead to ugly output in certain uncommon cases.
def write_multiline_address address
	html = '<div class="adr multilineaddress">'
	
	if address.street
		html += '<span class="street-address">' + address.street + '</span><br />'
	end

	if address.locality
		html += '<span class="locality">' + address.locality + '</span>, '
	end

	if address.region
		html += '<span class="region">' + address.region + '</span> '
	end

	if address.postalcode
		html += '<span class="postal-code">' + address.postalcode + '</span><br />'
	end

	if address.country
		html += '<span class="country-name">' + address.country + '</span>'
	end

	# Remove unnecessary formatting characters.
	# This only happens when some fields are missing.
	html = html.gsub(' ,<br />', '<br />')
	html = html.gsub('/<br />$/', '')

	html += '</div>' + "\n"
	return html
end

# Returns a string of HTML for a lat/long address.
def write_gps_address coordinates
	html = '<div class="adr geo">'
	html += coordinates
	html += '</div>' + "\n"
	return html
end

# Returns a string of HTML for a Japanese unformatted address.
# Sometimes Japanese addresses are just one long string.
def write_japanese_unformatted_address address
	html = '<div class="adr">'
	html += address
	html += '</div>' + "\n"
	return html
end

# Returns a string of HTML for a Japanese address.
def write_japanese_address address
	html = '<div class="adr">'
	html += address.country + '　'
	html += address.postalcode + ' '
	html += address.region
	html += address.locality
	html += address.street
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
		if is_gps_address? address.street
			html += write_gps_address address.street
		elsif address.street.start_with? '日本'
			html += write_japanese_unformatted_address address.street
		elsif address.country == '日本'
			html += write_japanese_address address
		elsif is_multiline_address? address
			html += write_multiline_address address
		else
			# Assume the contents are entirely in the street field.
			html += '<div class="adr">' + address.street + '</div>' + "\n"
		end
	end

	html += '</div>' + "\n"
	return html
end

# Returns a string of HTML with the contact's categories.
def write_category categories
	unless categories
		return ''
	end

	html = '<div class="categories">'

	categories.each do |category|
		html += '<span class="category">' + category + '</span>'
	end

	html += '</div>' + "\n"
	return html
end

# Converts a single Vcard to HTML.
def vcard_to_html card
	html = '<div class="vcard">' + "\n"
	html += write_category card.categories
	html += write_name card.name
	html += write_telephone card.telephones
	html += write_email card.emails
	html += write_url card.urls
	html += write_birthday card.birthday
	html += write_address card.addresses
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
