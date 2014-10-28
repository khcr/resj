FactoryGirl.define do

  factory :user do
    firstname "John"
    lastname  "Smith"
    email "foo@bar.com"
    password "12341"
    password_confirmation "12341"
    user_type { UserType.find_by_name("user") }
    confirmed true

    factory :unconfirmed_user do
      confirmed false
    end
  end

  factory :card do
    name "Waykup"
    description "Un super groupe de jeunes"
    street "Route du verdel 8"
    latitude 46
    longitude 7
    website "waykup.ch"
    association :user, firstname: "Bill", lastname: "Gates", email: "bill@gates.com"
    location { Location.find_by_official_name("Bulle") }
    status { Status.find_by_name("En cours de validation") }
    card_type { CardType.find_by_name("Groupe de jeunes") }

    after(:create) do |card|
      card.user.ownerships.create(element_id: Element.find_by_name('cards').id, ownership_type_id: OwnershipType.find_by_name('on_entry').id, id_element: card.id, right_read: true, right_update: true, right_create: true)
      card.user.ownerships.create(element_id: Element.find_by_name('cards/affiliations').id, ownership_type_id: OwnershipType.find_by_name('on_entry').id, id_element: card.id, right_create: true, right_delete: true, right_update: true, right_read: true)
    end

    factory :active_card do
      status { Status.find_by_name("En ligne") }
    end
  end

  factory :access_token do
    is_valid true
    exp_at 1.month.from_now
  end

  factory :ownership do
    transient do
      element_name 'cards'
      user_name 'John Smith'
      group_name nil
      type_name 'all_entries'
    end
    element { Element.find_by_name(element_name) }
    user { if group_name.nil? then User.find_by_firstname_and_lastname(*user_name.split()) else User.find_by_firstname(group_name) end }
    
    ownership_type { OwnershipType.find_by_name(type_name) }

    right_read false
    right_create false
    right_update false
    right_delete false
  end

  factory :affiliation, class: CardUser do
    user { User.find_by_firstname_and_lastname("John", "Smith") || create(:user) }
    card { Card.find_by_name("Waykup") || create(:card) }
    card_validated true
    user_validated true

    factory :recent_affiliation do
      updated_at 1.day.ago
    end
  end

end