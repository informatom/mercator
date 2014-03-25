if CONFIG[:mesonic] == "on"

  class Mesonic::Order < Mesonic::Sqlserver

    self.table_name = "t025"
    self.primary_key = "C000"

    scope :mesoyear, -> { where(mesoyear: Mesonic::AktMandant.mesoyear) }
    scope :mesocomp, -> { where(mesocomp: Mesonic::AktMandant.mesocomp) }
    default_scope { mesocomp.mesoyear }

    # --- Class Methods --- #

    def self.initialize_mesonic(order: nil, custom_order_number: nil)

      customer = order.customer
      timestamp = Time.now
      mesonic_kontenstamm_fakt = customer.mesonic_kontenstamm_fakt
      custom_order_number |= timestamp.strftime('%y%m%d%H%M%S') + timestamp.usec # timestamp, if custom order number not provided
      kontonummer = @customer.mesonic_kontenstamm.try(:kunde?) ? @customer.mesonic_kontenstamm.kontonummer : "09WEB"
      usernummer = customer.erp_contact_nr ? customer.erp_contact_nr : customer.id
      billing_method = order.billing_method.to_i == 1004 ?
                       mesonic_kontenstamm_fakt.c107 : IvellioVellin::Order.payment_methods2[ :"#{order.billing_method}" ].try(:to_i) #HAS 20140325 FIXME

      self.new(c000: kontonummer + "-" + custom_order_number,
               c004: order.billing_name,
               c005: order.billing_detail,
               c006: order.billing_street,
               c007: order.billing_postalcode,
               c008: order.billing_city,
               c010: order.shipping_name,
               c011: order.shipping_detail,
               c012: order.shipping_street,
               c013: order.shipping_postal,
               c014: order.shipping_postalcode,
               c017: order.billing_state_code,
               c019: order.shipping_state_code,
               c020: usernummer,
               c021: kontonummer,
               c022: custom_order_number,
               c023: "N", # druckstatus angebot
               c024: "N", # druckstatus auftragsbestätigung
               c025: "N", # durckstatus lieferschein
               c026: "N", # druckstatus faktura
               c027: timestamp, # datum angebot
               c030: customer.erp_account_nr, #### konto-lieferadresse
               c034: mesonic_kontenstamm_fakt.belegart.c014, # #### belegart
               c035: mesonic_kontenstamm_fakt.c077, # belegart
               c036: mesonic_kontenstamm_fakt.c065, # vertreternummer
               c037: 0, # nettotage
               c038: 0, # skonto%1
               c039: 0, # skontotage1
               c040: 0, # summenrabatt
               c041: 0, # fw-zeile
               c047: mesonic_kontenstamm_fakt.c066,  # preisliste
               c049: 0, # fw einheit
               c050: 0, # fw-faktor
               c051: billing_method
               c053: mesonic_kontenstamm_fakt.c122, # kostentraeger
               c054: 400, # kostenstelle
               c056: 0, # skonto%2
               c057: 0, # skontotage2
               c059: timestamp, # datum d. erstanlage
               c074: 0, # kennzeichen f FW-Umrechung
               c075: 0, # flag für Webinterface
               c076: 0, # Dokumenten ID
               c077: 0, # FW-Notierungsflag
               c078: 0, # xml-erweiterung
               c080: 0, # filler
               c081: nil, #HAS 20140325 FIXME: order.billing_name2 Adresse erweitern
               c082: nil, #HAS 20140325 FIXME: order.shipping_name2 Adresse erweitern
               c086: 0, # teilliefersperre
               c088: 0, # priorität
               c089: order.shipping_method.to_i #HAS 20140325 FIXME
               c090: 0, # freier text 2
               c091: 0, # freier text 3
               c092: 0, # freier text 4
               c093: 0, # sammelrechnung
               c094: 0, # methode
               c095: 0, # ausprägung 1
               c096: 0, # ausprägung 2
               c097: order.billing_method.to_i #HAS 20140325 FIXME
               c098: 101, # freigabekontrolle angebot
               c099: order.sum_incl_vat, # kumulierter zahlungsbetrag
               c100: order.sum_incl_vat, # endbetrag
               c102: 0, # rohertrag
               c103: timestamp + 3.days, #
               c104: 0, # ansprechpartner rechnungsadresse
               c105: 0, # ansprechpartner lieferadresse
               c106: 0, # fremdwährungskurs
               c109: -1, # kontrakttyp
               c111: 2, # exim durchgeführte änderungen
               c113: c021, #  c113: "09WEB" # konto rechnungsadresse
               c114: 0, # anzahlungsbetrag
               c115: 101, # freigabekontrolle auftrag
               c116: 101, # freigabekontrolle lieferschein
               c117: 101, # freigabekontrolle faktura
               c118: 0, # euro rohertrag
               c120: 0, # fw-einheit für storno
               c121: 0, # sortierung
               c123: 0, # textkennzeichen konto
               c126: 0, # aktionsplanzeile
               c127: 0, # karenztage
               c137: 2,
               c139: 0,
               c140: 0,
               c141: 0,
               c142: 0,
               c143: 0,
               C151: 8,
               C152: "900001",
               C153: 0,
               C154: 0,
               C155: 0,
               C156: 0,
               C157: 0,
               C158: 0,
               C159: 0,
               C160: 0,
               mesocomp: Mesonic::AktMandant.mesocomp,
               mesoyear: Mesonic::AktMandant.mesoyear,
               mesoprim: c000 + "-" + Mesonic::AktMandant.mesocomp + "-" + Mesonic::AktMandant.mesoyear )
      end
    end

    # --- Instance Methods --- #

    def readonly?  # prevents unintentional changes
      true
    end
  end

end