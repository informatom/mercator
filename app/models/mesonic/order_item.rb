if CONFIG[:mesonic] == "on"

  class Mesonic::OrderItem < Mesonic::Sqlserver

    self.table_name = "T026"
    self.primary_key = "c000"

    belongs_to :inventory, :foreign_key => "C003"

    attr_accessor :cart_item
    attr_accessor :mesonic_order

    # --- Class Methods --- #

    def self.initialize_mesonic(mesonic_order: nil, lineitem: nil, customer: nil, index: nil)
      id = mesonic_order.C000 + "-" + "%06d" % (index + 1 )
      self.new(c000: id,
               c003: lineitem.inventory.article_number,
               c004: lineitem.inventory.Bezeichnung,
               c005: lineitem.menge, # menge bestellt
               c006: lineitem.menge, # menge geliefert
               c007: lineitem.einzelpreis, # einzelpreis
               c008: 0, # zeilenrabatt 1 und 2
               c009: 4002, # erlöskonto
               c010: lineitem.inventory.Steuersatzzeile, # umsatzsteuer prozentsatz #FIXME
               c011: 1, # statistikkennzeichen
               c012: lineitem.inventory.ArtGruppe, # artikelgruppe #FIXME
               c013: 0, # liefertage
               c014: lineitem.inventory.Provisionscode, # provisionscode #FIXME
               c015: nil, # colli
               c016: 0, # menge bereits geliefert
               c018: 0, # faktor 1 nach formeleingabe
               c019: 0, # faktor 2 nach formeleingabe
               c020: 0, # faktor 3 nach formeleingabe
               c021: 0, # zeilenrabatt %1
               c022: 0, # zeilenrabatt %2
               c023: 0, # einstandspreis
               c024: nil, # umstatzsteuercode
               c025: mesonic_order.c027, # lieferdatum
               c026: 400, # kostenstelle
               c027: 0, # lieferwoche
               c031: lineitem.gesamtwert, # gesamtwert #FIXME
               c032: 0, # positionslevel
               c033: nil, # positionsnummer text
               c034: lineitem.inventory.Gewicht, # gewicht #FIXME
               c035: 0, # einstandspreis KZ
               c042: 1, # datentyp
               c044: mesonic_order.c021, # kontonummer
               c045: mesonic_order.c022, # laufnummer
               c046: 99, # vertreternummer
               c047: nil, # prodflag
               c048: mesonic_order.c027.year, # lieferjahr
               c052: 0, # stat. wert
               c054: 0, # bewertungspreis editieren
               c055: lineitem.inventory.Auspraegungsflag, #FIXME
               c056: customer.erp_account_nr, # interessentenkontonummer
               c057: 0, # lagerbestand ändern J/N
               c058: 0, # key für dispozeile
               c059: 0, # zeilennummer d kundenauftrags
               c060: 0, # temp gridzeilennumer
               c061: 0, # zeilennummer des auftrages
               c062: 0, # key handels stückliste
               c063: 0, # flag für update ( telesales )
               c068: 1, # lieferantenartikelnummer
               c070: 0, # colli faktor
               c071: 0, # umrechnungsfaktor colli
               c072: 0, # umrechnungsfaktor menge 2
               c073: 1, # preisartenflag
               c074: 0, # flag für aufgeteilte hauptartikel
               c075: 0, # flag v lieferantenlieferung aufteilen
               c077: 0, # preisupdateflag
               c078: index + 1, # zeilennummer (intern)
               c081: 0, # nummer des kontraktpreises
               c082: 0, # menge 2
               c083: lineitem.inventory.Steuersatzzeile * 10, #FIXME
               c085: 2, # exim durchgeführt änderungen
               c086: 0, # EURO einstandspreis
               c087: 0, # bnk-prozent
               c088: 0, # ausgebuchte menge
               c091: 0, # textkennzeichen artikel
               c092: 0, # betrag bezugskosten
               c098: 0, # flag reservierung
               c099: 0, # rückstandsmenge
               c100: 0,
               c101: 0,
               c104: 0,
               mesocomp: Mesonic::AktMandant.mesocomp,
               mesoyear: Mesonic::AktMandant.mesoyear,
               mesoprim: id + "-" + Mesonic::AktMandant.mesocomp + "-" + Mesonic::AktMandant.mesoyear,
               C106: "",
               C107: 0,
               C108: "",
               C109: 0 )
    end

    # --- Instance Methods --- #

    def readonly?  # prevents unintentional changes
      true
    end
  end
end