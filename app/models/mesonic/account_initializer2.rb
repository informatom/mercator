class Mesonic::AccountInitializer2

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
    initialize_ivellio_customer!
    initialize_mesonic_kontakte_stamm!
    initialize_mesonic_kontenstamm!
    initialize_mesonic_kontenstamm_adresse!
    initialize_mesonic_kontenstamm_fibu!
    initialize_mesonic_kontenstamm_fakt!
  end

  ## check if all models are valid
  def valid?
    models.collect(&:valid?).all?
  end

  ## save all models and return success
  def save
    models.collect(&:save).all?
  end

  #### call initialize procedures #####
  def initialize_ivellio_customer!
    ivellio_customer_proc.call( @ivellio_customer )
  end

  def initialize_mesonic_kontakte_stamm!
    mesonic_kontakte_stamm_proc.call( @mesonic_kontakte_stamm )
  end

  def initialize_mesonic_kontenstamm!
    mesonic_kontenstamm_proc.call( @mesonic_kontenstamm )
  end

  def initialize_mesonic_kontenstamm_fakt!
    mesonic_kontenstamm_fakt_proc.call( @mesonic_kontenstamm_fakt )
  end

  def initialize_mesonic_kontenstamm_adresse!
    mesonic_kontenstamm_adresse_proc.call( @mesonic_kontenstamm_adresse )
  end

  def initialize_mesonic_kontenstamm_fibu!
    mesonic_kontenstamm_fibu_proc.call( @mesonic_kontenstamm_fibu )
  end

  ### initialize procedures #####
  def ivellio_customer_proc
    lambda { |a|
      a.name = @mesonic_kontenstamm_adresse.name
      a.mesonic_account_id = @kontaktenummer
      a.account_number = @kontonummer
      a.account_number_mesoprim = @kontonummer_mesoprim
      a.mesonic_account_mesoprim = @kontaktenummer_mesoprim
    }
  end

  def mesonic_kontenstamm_proc
    lambda { |a|
      a.c002 = @kontonummer
      a.c004 = "4"
      a.c003 = @ivellio_customer.name
      a.c084 = ""
      a.c086 = @timestamp
      a.c102 = @kontonummer
      a.c103 = @kontonummer
      a.c127 = "050-"
      a.c069 = 2 ## KZ Änderungen durchgeführt ????
      a.c146 = 0
      a.c155 = 0
      a.c156 = 0
      a.c172 = 0
      a.C253 = 0
      a.C254 = 0
      a.mesosafe = 0
      a.mesocomp = @mesocomp
      a.mesoyear = @mesoyear
      a.mesoprim = "#{@kontonummer}-#{@mesocomp}-#{@mesoyear}"
    }
  end

  def mesonic_kontenstamm_adresse_proc
    lambda { |a|
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
    }
  end

  def mesonic_kontakte_stamm_proc
    lambda { |a|
      a.c039 = @kontonummer
      a.id = @kontaktenummer
      a.c000 = @kontaktenummer
      a.c025 = @ivellio_customer.email
      a.c033 = 0
      a.c035 = 0 ### geschlecht 0/1 ... ??
      a.c040 = 1
      a.c042 = 0
      a.c043 = 0
      a.c054 = 0 ## !!! Exim Kennzeichen: 0, 1, 2 ?????
      a.c059 = 0
      a.c060 = 0
      a.C061 = @kontaktenummer
      a.mesocomp = @mesocomp
      a.mesoyear = @mesoyear
      a.mesoprim    = "#{@kontaktenummer}-#{@mesocomp}-#{@mesoyear}"
    }
  end

  def mesonic_kontenstamm_fibu_proc
    lambda { |a|
      a.c005 = 0
      a.c012 = 0
      a.c007 = "1300"
      a.c008 = "1300"
      a.c100 = "017"
      a.c104 = @kontonummer
      a.c009 = 0
      a.c163 = -1
      a.c174 = 0
      a.C185 = 0
      a.c153 = 0
      a.c164 = 0
      a.c175 = 0
      a.c176 = 0
      a.C186 = 0
      a.c067 = 0
      a.C189 = 0
      a.c058 = 0
      a.c124 = 0
      a.c135 = 0
      a.C190 = 0
      a.c057 = 0
      a.c059 = 0
      a.c114 = 0
      a.c136 = 0
      a.c115 = 0
      a.c137 = 0
      a.c006 = 0
      a.c061 = 0
      a.c063 = 0
      a.c151 = 0
      a.c173 = 0
      a.mesocomp = @mesocomp
      a.mesoyear = @mesoyear
      a.mesoprim = "#{@kontonummer}-#{@mesocomp}-#{@mesoyear}"
    }
  end

  def mesonic_kontenstamm_fakt_proc
    lambda { |a|
      a.c060 = 0
      a.c062 = 0
      a.c066 = 3
      a.c065 = 99
      a.c068 = 0
      a.c070 = 0
      a.c071 = 0
      a.c072 = 0
      a.c077 = 21
      a.c107 = "017"
      a.c108 = 0
      a.c109 = 0
      a.c110 = 0
      a.c111 = 0
      a.c112 = @kontonummer
      a.c113 = 0
      a.c120 = 0
      a.c121 = 1
      a.c132 = 0
      a.c133 = 0
      a.c134 = 0
      a.c148 = 0
      a.c149 = 0
      a.c150 = 0
      a.c171 = 0
      a.c183 = 0
      a.C184 = 0
      a.mesocomp = @mesocomp
      a.mesoyear = @mesoyear
      a.mesoprim = "#{@kontonummer}-#{@mesocomp}-#{@mesoyear}"
    }
  end
end