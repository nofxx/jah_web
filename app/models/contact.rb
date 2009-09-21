class Contact < ActiveRecord::Base
  belongs_to :contactable, :polymorphic => true
  # has_and_belongs_to_many :notifiers

  symbolize :kind, :in => [:mail, :tel, :cel, :nextel, :skype,
                          :msn, :sms, :fax, :other], :i18n => false

  validates_presence_of :value
  validates_length_of :value, :in => (3..50), :allow_blank => true
  validates_length_of :info, :maximum => 255, :allow_nil => true

  validates_format_of :value, :with => /(.+)@(.+)\.(.{2})/,
    :if => lambda { |s| s.kind == :email }

  named_scope :mail, :conditions => {:contato_type => :mail }
  named_scope :tel,  :conditions => {:contato_type => :tel }
  named_scope :cel,  :conditions => {:contato_type => :cel }
  named_scope :sms,  :conditions => {:contato_type => :sms }

end





# == Schema Information
#
# Table name: contacts
#
#  id               :integer         not null, primary key
#  contactable_id   :integer(20)
#  contactable_type :string(20)
#  kind             :string(5)       not null
#  value            :string(50)      not null
#  info             :text
#

