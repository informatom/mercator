class Mesonic::AccountInitializer

  attr_accessor :kontonummer, :kontaktenummer
  attr_accessor :mesocomp, :mesoyear
  attr_accessor :kontonummer_mesoprim, :kontaktenummer_mesoprim
  attr_accessor :ivellio_customer
  attr_accessor :mesonic_kontakte_stamm
  attr_accessor :mesonic_kontenstamm
  attr_accessor :mesonic_kontenstamm_adresse

  def initialize( account_params = {} )
    @timestamp = Time.now

    @params = account_params

    @ivellio_customer = IvellioVellin::Customer.new( @params )

    @mesonic_kontakte_stamm   = @ivellio_customer.mesonic_account = Mesonic::Account.new
    @mesonic_kontenstamm      = @ivellio_customer.mesonic_kontenstamm = Mesonic::Kontenstamm.new
    @mesonic_kontenstamm_fakt = @ivellio_customer.mesonic_kontenstamm_fakt = Mesonic::KontenstammFakt.new
    @mesonic_kontenstamm_fibu = @ivellio_customer.mesonic_kontenstamm_fibu = Mesonic::KontenstammFibu.new
    @mesonic_kontenstamm_adresse = @ivellio_customer.mesonic_kontenstamm_adresse

    @kontonummer    = Mesonic::Kontenstamm.next_kontonummer
    @kontaktenummer = Mesonic::KontakteStamm.next_kontaktenummer

    @mesocomp     = Mesonic::AktMandant.mesocomp
    @mesoyear     = Mesonic::AktMandant.mesoyear

    @kontonummer_mesoprim = [@kontonummer, @mesocomp, @mesoyear].join("-")
    @kontaktenummer_mesoprim = [@kontaktenummer, @mesocomp, @mesoyear].join("-")
  end

  def models
    [ @mesonic_kontakte_stamm,
      @mesonic_kontenstamm,
      @mesonic_kontenstamm_adresse,
      @mesonic_kontenstamm_fibu,
      @mesonic_kontenstamm_fakt ]
  end

  ## main initializer
  def initialize_account!
    ivellio_customer(@ivellio_customer)
    mesonic_kontakte_stamm_proc.call( @mesonic_kontakte_stamm )
    mesonic_kontenstamm(@mesonic_kontenstamm)
    mesonic_kontenstamm_adresse(@mesonic_kontenstamm_adresse)
    mesonic_kontenstamm_fibu(@mesonic_kontenstamm_fibu)
    mesonic_kontenstamm_fakt(@mesonic_kontenstamm_fakt)
  end

  def valid?
    models.collect(&:valid?).all?
  end

  def save
    models.collect(&:save).all?
  end

  def self.ivellio_customer(customer: nil)
    c = customer
    c.name = @mesonic_kontenstamm_adresse.name
    c.mesonic_account_id = @kontaktenummer
    c.account_number = @kontonummer
    c.account_number_mesoprim = @kontonummer_mesoprim
    c.mesonic_account_mesoprim = @kontaktenummer_mesoprim
  end

  def self.mesonic_kontenstamm(kontenstamm: nil)
    k = kontenstamm
    k.c002 = @kontonummer
    k.c004 = "4"
    k.c003 = @ivellio_customer.name
    k.c084 = ""
    k.c086 = @timestamp
    k.c102 = @kontonummer
    k.c103 = @kontonummer
    k.c127 = "050-"
    k.c069 = 2 ## KZ Änderungen durchgeführt ????
    k.c146 = 0
    k.c155 = 0
    k.c156 = 0
    k.c172 = 0
    k.C253 = 0
    k.C254 = 0
    k.mesosafe = 0
    k.mesocomp = @mesocomp
    k.mesoyear = @mesoyear
    k.mesoprim = "#{@kontonummer}-#{@mesocomp}-#{@mesoyear}"
  end

  def self.mesonic_kontenstamm_adresse(adresse: nil)
    a = adresse
    a.firstname = a.name.split(/\s/).first
    a.lastname  =  a.name.split(/\s/).last
    a.c001 = @kontonummer
    a.c116 = @ivellio_customer.email
    a.c157 = 0
    a.c180 = nil
    a.c181 = nil
    a.c182 = 0
    a.C241 = 0
    a.mesocomp = @mesocomp
    a.mesoyear = @mesoyear
    a.mesoprim = "#{@kontonummer}-#{@mesocomp}-#{@mesoyear}"
  end

  def self.mesonic_kontakte_stamm(kontakte_stamm: nil)
    ks = kontakte_stamm
    ks.c039 = @kontonummer
    ks.id = @kontaktenummer
    ks.c000 = @kontaktenummer
    ks.c025 = @ivellio_customer.email
    ks.c033 = 0
    ks.c035 = 0 ### geschlecht 0/1 ... ??
    ks.c040 = 1
    ks.c042 = 0
    ks.c043 = 0
    ks.c054 = 0 ## !!! Exim Kennzeichen: 0, 1, 2 ?????
    ks.c059 = 0
    ks.c060 = 0
    ks.C061 = @kontaktenummer
    ks.mesocomp = @mesocomp
    ks.mesoyear = @mesoyear
    ks.mesoprim = "#{@kontaktenummer}-#{@mesocomp}-#{@mesoyear}"
  end

  def self.mesonic_kontenstamm_fibu(kontenstamm_fibu: nil)
    kf = kontenstamm_fibu
    kf.c005 = 0
    kf.c012 = 0
    kf.c007 = "1300"
    kf.c008 = "1300"
    kf.c100 = "017"
    kf.c104 = @kontonummer
    kf.c009 = 0
    kf.c163 = -1
    kf.c174 = 0
    kf.C185 = 0
    kf.c153 = 0
    kf.c164 = 0
    kf.c175 = 0
    kf.c176 = 0
    kf.C186 = 0
    kf.c067 = 0
    kf.C189 = 0
    kf.c058 = 0
    kf.c124 = 0
    kf.c135 = 0
    kf.C190 = 0
    kf.c057 = 0
    kf.c059 = 0
    kf.c114 = 0
    kf.c136 = 0
    kf.c115 = 0
    kf.c137 = 0
    kf.c006 = 0
    kf.c061 = 0
    kf.c063 = 0
    kf.c151 = 0
    kf.c173 = 0
    kf.mesocomp = @mesocomp
    kf.mesoyear = @mesoyear
    kf.mesoprim = "#{@kontonummer}-#{@mesocomp}-#{@mesoyear}"
  end

  def self.mesonic_kontenstamm_fakt(kontenstamm_fakt: nil)
    kf = kontenstamm_fakt
    kf.c060 = 0
    kf.c062 = 0
    kf.c066 = 3
    kf.c065 = 99
    kf.c068 = 0
    kf.c070 = 0
    kf.c071 = 0
    kf.c072 = 0
    kf.c077 = 21
    kf.c107 = "017"
    kf.c108 = 0
    kf.c109 = 0
    kf.c110 = 0
    kf.c111 = 0
    kf.c112 = @kontonummer
    kf.c113 = 0
    kf.c120 = 0
    kf.c121 = 1
    kf.c132 = 0
    kf.c133 = 0
    kf.c134 = 0
    kf.c148 = 0
    kf.c149 = 0
    kf.c150 = 0
    kf.c171 = 0
    kf.c183 = 0
    kf.C184 = 0
    kf.mesocomp = @mesocomp
    kf.mesoyear = @mesoyear
    kf.mesoprim = "#{@kontonummer}-#{@mesocomp}-#{@mesoyear}"
  end
end