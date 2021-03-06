namespace :db do

	desc "Ownership to receive the notification email when a card is created"
	task notification_ownership: :environment do
		Ownership.create(element: Element.find_by_name('admin/card_statuses'), user: User.find_by_email('nkcr.je@gmail.com'), ownership_type: OwnershipType.find_by_name('all_entries'), right_update: true)
	end

	desc "Update element name for card affiliations"
	task affiliation_element: :environment do
		Element.find_by_name('card_affiliations').update_attribute(:name, 'cards/affiliations')
	end

  desc "Assign default newsletters"
  task assign_newsletters: :environment do
    User.users.each do |user|
      user.newsletters = Newsletter.all
    end
  end

  desc "Add a published date to the previous articles"
  task publish_articles: :environment do
    Article.all.each do |article|
      article.update_attribute(:published_at, Time.now)
    end
  end

  desc "Update owner's permissions to delete and transfer his card"
  task update_owner_permissions: :environment do
    action = Action.find_or_create_by(name: "transfer")
    Card.all.each do |card|
      user = card.user
      ownership = Ownership.search(element: "cards", type: "on_entry", user: user, id_element: card.id).first
			if ownership.nil?
        puts "Ownership not found: card #{card.name}"
      else
        ownership.update_attribute(:right_delete, true)
        ownership.actions << action
      end
    end
  end

end
