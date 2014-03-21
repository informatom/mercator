class IvellioVellin::Customer < ActiveRecord::Base
  attr_accessor :is_customer, :mesonic_account_number, :agb
  attr_accessible :mesonic_kontenstamm_adresse_attributes, :mesonic_kontenstamm_attributes, :email, :name,
                  :password, :password_confirmation, :mesonic_account_number, :is_customer, :agb

  belongs_to :mesonic_account, :class_name => "::Mesonic::Account", :foreign_key => "mesonic_account_mesoprim"
  [ :kontonummer, :kunde?, :interessent? ].each { |m| delegate m, :to => :mesonic_account }

  belongs_to :mesonic_kontenstamm, :class_name => "::Mesonic::Kontenstamm", :foreign_key => "account_number_mesoprim"
  accepts_nested_attributes_for :mesonic_kontenstamm, :allow_destroy => false

  belongs_to :mesonic_kontenstamm_fakt, :class_name => "::Mesonic::KontenstammFakt", :foreign_key => "account_number_mesoprim"
  accepts_nested_attributes_for :mesonic_kontenstamm_fakt, :allow_destroy => false

  belongs_to :mesonic_kontenstamm_fibu, :class_name => "::Mesonic::KontenstammFibu", :foreign_key => "account_number_mesoprim"
  accepts_nested_attributes_for :mesonic_kontenstamm_fibu, :allow_destroy => false

  belongs_to :mesonic_kontenstamm_adresse, :class_name => "::Mesonic::KontenstammAdresse", :foreign_key => "account_number_mesoprim"
  accepts_nested_attributes_for :mesonic_kontenstamm_adresse, :allow_destroy => false

  validates_associated :mesonic_kontenstamm_adresse

  def set_account_number_mesoprim
    self.account_number_mesoprim = [ self.account_number, Mesonic::AktMandant.mesocomp, Mesonic::AktMandant.mesoyear ].join("-")
  end

  def set_mesonic_account_mesoprim
    self.mesonic_account_mesoprim = [ self.mesonic_account_id, Mesonic::AktMandant.mesocomp, Mesonic::AktMandant.mesoyear ].join("-")
  end
end