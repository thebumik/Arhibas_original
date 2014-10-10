class ContactForm < MailForm
  append :remote_ip, :user_agent, :session

  subject { |c| "Arhibas.com - Contacted by #{c.name}" }
  recipients "trincanu@gmail.com" #office@arhibas.com

  attribute :name,      :validate => true
  attribute :email,     :validate => /^([^@]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  attribute :company
  attribute :address
  attribute :city
  attribute :country
  attribute :phone
  attribute :message
  attribute :file,      :attachment => true
end
