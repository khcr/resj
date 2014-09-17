module ApplicationHelper

	def present(table)
		render 'table', presenter: table
	end

	def link_to_active(label,path)
		link_to label, path, class: (current_page?(path)? 'active' : nil)
	end

	def map_points(cards)
		raw cards.map {|a| 
			[
			a.latitude,
			a.longitude,
			"#{content_tag :p, a.card_type.name, class:'type'} #{a.name} #{link_to 'voir fiche', card_path(a)}",
			asset_path("map/images/marker-icon-#{map_marker_color(a)}.png"),
			a.id
			] 
		}
	end

	def map_marker_color(card)
		case card.card_type.name
		when "Groupe de jeunes"
			color = "red"
		when "Groupe de jeunes adultes"
			color = "green"
		when "Groupe d'action"
			color = "orange"
		when "Oeuvre jeunesse"
			color = "blue"
		when "Réseau régional"
			color = "violet"
		end
		return color
	end

	def mask_email(email)
		email.gsub(/(?<=.{2}).(.*@)/, '*****@')
	end

	def map_users(users)
		users.map{ |user| [user.full_name, user.email]}
	end

	def color_color_type(type)
		case type.name
		when "Groupe de jeunes"
			color = "red"
		when "Groupe de jeunes adultes"
			color = "green"
		when "Groupe d'action"
			color = "orange"
		when "Oeuvre jeunesse"
			color = "blue"
		when "Réseau régional"
			color = "violet"
		end
		return color
	end

	def accepted_canton
		return %w[FR VD VS NE GE JU BE]
	end

	def paginate_range(collection)
		count = collection.count
	  endnumber = collection.offset + collection.per_page > count ? count : collection.offset + collection.per_page
		startnumber = collection.count > 0 ? collection.offset+1 : 0
		"#{startnumber}-#{endnumber} de #{count}"  
	end

end
