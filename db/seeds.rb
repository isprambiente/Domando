# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.destroy_all
Faq.destroy_all
users = [
  {username: 'admin', label: 'Admin', admin: true, created_at: Time.zone.now, updated_at: Time.zone.now},
  {username: 'editor', label: 'Editor', editor: true, created_at: Time.zone.now, updated_at: Time.zone.now},
  {username: 'user', label: 'User', structure: 'Struttura2', created_at: Time.zone.now, updated_at: Time.zone.now},
  {username: 'user2', label: 'User2', structure: 'Struttura1', created_at: Time.zone.now, updated_at: Time.zone.now}
]
faqs = [
  {title: "Richiedere un nuovo computer", approve: true, category_list: ['informatica', 'computer'], structure: 'Struttura1', content: "Per qualsiasi informazione contattare l'ufficio preposto."},
  {title: "Richiedere il cambio password di dominio", category_list: ['informatica', 'dominio', 'password'], approve: true, structure: 'Struttura1', content: "Per cambiare la password inviare una email a test@domain.com."},
  {title: "Richiedere aiuto per il cartellino", category_list: ['informatica', 'cartellino'], approve: true, structure: 'Struttura2', content: "Per qualsiasi informazione contattare l'ufficio preposto."},
  {title: "Richiedere un nuovo DNS", category_list: ['informatica', 'dns'], approve: true, structure: 'Struttura1', content: "Per qualsiasi richiesta contattare l'ufficio preposto."}
]
User.create(users)
Faq.create(faqs)
