require 'spec_helper'

describe MercatorIcecat::Metadatum do
  it "is valid with product, path, icecat_updated_at, quality, supplier_id, icecat_product_id," +
     "prod_id, product_number, cat_id, on_market, icecat_model_name and product_view" do
    expect(build :metadatum).to be_valid
  end

  it {should belong_to :product}


  # ---  Class Methods  --- #

  describe "import_catalog" do
    it "imports full metadata" do
      FileUtils.cp(Rails.root.join("vendor","engines","mercator_icecat", "materials", "icecat-test-index.xml"),
                   Rails.root.join("vendor","catalogs","files.index.xml"))

      MercatorIcecat::Metadatum.import_catalog(full: true)

      @metadatum = MercatorIcecat::Metadatum.first
      expect(@metadatum.path).to eql "export/freexml.int/INT/28461642.xml"
      expect(@metadatum.icecat_updated_at).to eql Time.new(2015, 06, 26, 06, 13 ,19)
      expect(@metadatum.quality).to eql "ICECAT"
      expect(@metadatum.supplier_id).to eql "1"
      expect(@metadatum.icecat_product_id).to eql "28461642"
      expect(@metadatum.product_number).to eql nil
      expect(@metadatum.cat_id).to eql "222"
      expect(@metadatum.on_market).to eql "1"
      expect(@metadatum.icecat_model_name).to eql "24uh"
      expect(@metadatum.product_view).to eql "485"

      File.delete(Rails.root.join("vendor","catalogs","files.index.xml"))
    end

    it "imports daily metadata" do
      FileUtils.cp(Rails.root.join("vendor","engines","mercator_icecat", "materials", "icecat-test-index.xml"),
                   Rails.root.join("vendor","catalogs", Date.today.to_s + "-index.xml"))

      MercatorIcecat::Metadatum.import_catalog(full: false)

      @metadatum = MercatorIcecat::Metadatum.first
      expect(@metadatum.path).to eql "export/freexml.int/INT/28461642.xml"
      expect(@metadatum.icecat_updated_at).to eql Time.new(2015, 06, 26, 06, 13 ,19)
      expect(@metadatum.quality).to eql "ICECAT"
      expect(@metadatum.supplier_id).to eql "1"
      expect(@metadatum.icecat_product_id).to eql "28461642"
      expect(@metadatum.product_number).to eql nil
      expect(@metadatum.cat_id).to eql "222"
      expect(@metadatum.on_market).to eql "1"
      expect(@metadatum.icecat_model_name).to eql "24uh"
      expect(@metadatum.product_view).to eql "485"

      File.delete(Rails.root.join("vendor","catalogs", Date.today.to_s + "-index.xml"))
    end
  end


  describe "assign_products" do
    before :each do
      @product = create(:product, alternative_number: "D9190B")
      @metadatum = create(:metadatum, product_id: nil)
    end

    it "works for missing products" do
      MercatorIcecat::Metadatum.assign_products(only_missing: true)
      @metadatum.reload
      expect(@metadatum.product_id).to eql @product.id
    end

    it "works for all products" do
      @metadatum.update(product_id: 17)

      MercatorIcecat::Metadatum.assign_products(only_missing: false)
      @metadatum.reload
      expect(@metadatum.product_id).to eql @product.id
    end
  end


  describe "download" do
    before :each do
      @filename = Rails.root.join("vendor", "xml", "1286.xml")
      File.delete(@filename) if File.exist?(@filename)
      @metadatum = create(:metadatum, product_id: 17)
    end

    after :each do
      File.delete(@filename) if File.exist?(@filename)
    end

    it "downloads from today, if requested" do
      MercatorIcecat::Metadatum.download(from_today: true)
      expect(File).to exist(@filename)
    end

    it "dosn't download, if today requested and updated_at is older" do
      @metadatum.update(updated_at: Time.now - 1.month)
      MercatorIcecat::Metadatum.download(from_today: true)
      expect(File).not_to exist(@filename)
    end

    it "downloads all, if requested" do
      MercatorIcecat::Metadatum.download(from_today: false)
      expect(File).to exist(@filename)
    end
  end


  # ---  Instance Methods  --- #

  describe "download" do
    before :each do
      @filename = Rails.root.join("vendor", "xml", "1286.xml")
      File.delete(@filename) if File.exist?(@filename)
      @metadatum = create(:metadatum, product_id: nil)
    end

    after :each do
      File.delete(@filename) if File.exist?(@filename)
    end

    it "downloads from today, if requested" do
      @metadatum.download(overwrite: true)
      expect(File).to exist(@filename)
    end

    it "returns nil, if no override and file exists" do
      @metadatum.download(overwrite: true)
      expect(@metadatum.download(overwrite: false)).to eql false
    end

    it "returns false, if no path in metadatum" do
      @metadatum.update(path: nil)
      expect(@metadatum.download(overwrite: true)).to eql false
    end
  end


  describe "update_product" do
    before :each do
      @product = create(:product, alternative_number: "HP-K9J77EA",
                                  photo: nil)
      @metadatum = create(:second_metadatum, product_id: @product.id)
      @metadatum.download(overwrite: true)
    end

    after :each do
      @filename = Rails.root.join("vendor", "xml", "25880804.xml")
      File.delete(@filename) if File.exist?(@filename)
    end

    it "updates attributes" do
      @metadatum.update_product(initial_import: true)
      @product.reload

      expect(@product.description_de).to eql "Intel Core i3-5010U Processor (3M Cache, 2.10 GHz)," +
      " 4GB DDR3L 1600MHz, 500GB SATA HDD, 33.782 cm (13.3 \") HD LED 1366 x 768, Gigabit LAN," +
      " WLAN, Bluetooth, HD WebCam, Windows 7 Professional 64-bit / Windows 8.1 Pro"

      expect(@product.description_en).to eql "Intel Core i3-5010U Processor (3M Cache, 2.10 GHz)," +
      " 4GB DDR3L 1600MHz, 500GB SATA HDD, 33.782 cm (13.3 \") HD LED 1366 x 768, Gigabit LAN," +
      " WLAN, Bluetooth, HD WebCam, Windows 7 Professional 64-bit / Windows 8.1 Pro"

      expect(@product.long_description_de.first(100)).to eql "Das kompakte HP ProBook 430 mit" +
      " optionalem 10-Punkt-Touchscreen1, schlankem Design und Technologie d"

      expect(@product.long_description_en.first(100)).to eql "The compact HP ProBook 430 G2 with" +
      " optional 10-point touchscreen, sleek design, and latest generatio"

      expect(@product.warranty_de).to eql "e: 1 Jahr eingeschränkte Upgrades verfügbar, separat" +
      " erhältlich), 1 Jahr eingeschränkte e auf den primären Akku"

      expect(@product.warranty_en).to eql ""
    end

    it "creates property groups" do
      @metadatum.update_product
      expect(@product.property_groups.*.icecat_id.uniq).to eql [32, 33, 36, 35, 108, 109, 106, 110,
        762, 1403, 1711, 2686, 2687, 2933, 3024, 4124, 6417, 6416, 7946, 8602, 10385, 10674]

      expect(@product.property_groups.*.name_de.uniq).to eql ["Optisches Laufwerk", "Bildschirm",
        "Anschlüsse und Schnittstellen", "Prozessor", "Gewicht & Abmessungen", "Energie", "Speicher",
        "Audio", "Tastatur", "Betriebsbedingungen", "Netzwerk", "Sicherheit", "Zertifikate",
        "Software", "Kamera", "Speichermedien", "Weitere Spezifikationen", "Verpackungsinformation",
        "Batterie", "Grafik", "Prozessor Besonderheiten", "Design"]

      expect(@product.property_groups.*.name_en.uniq).to eql ["Optical drive", "Display",
        "Ports & interfaces", "Processor", "Weight & dimensions", "Power", "Memory", "Audio",
        "Keyboard", "Operational conditions", "Networking", "Security", "Certificates", "Software",
        "Camera", "Storage", "Other features", "Packaging data", "Battery", "Graphics",
        "Processor special features", "Design"]

      expect(@product.property_groups.*.position.uniq).to eql [32, 33, 36, 38, 108, 109, 111, 113,
        762, 1404, 1711, 2686, 2687, 2933, 3024, 4128, 6417, 6421, 7947, 8602, 10385, 10677]
    end

    it "creates properties" do
      @metadatum.update_product
      expect(@product.properties.*.icecat_id.uniq[0..19]).to eql  [7, 39, 47, 94, 427, 430, 432, 434,
        440, 442, 667, 672, 703, 730, 757, 771, 838, 902, 904, 903]

      expect(@product.properties.*.position.uniq[0..19]).to eql [7, 39, 49, 94, 430, 432, 433, 435, 442,
        446, 667, 681, 704, 738, 759, 786, 838, 907, 909, 910]

      expect(@product.properties.*.name_de.uniq[0..19]).to eql ["Festplattenkapazität", "Seitenverhältnis",
        "Prozessor", "Gewicht", "Interner Speichertyp", "Festplatten-Drehzahl", "WLAN-Standards",
        "Batterietechnologie", "Eingabegerät", "Audio-System", "Höhe bei Betrieb", "Speichersteckplätze",
        "Luftfeuchtigkeit in Betrieb", "Kompatible Speicherkarten", "Temperaturbereich bei Lagerung",
        "Formfaktor", "Energy Star-zertifiziert", "Netzteil Eingansgsspannung",
        "Netzteil Ausgangsspannung", "Netzteilfrequenz"]

      expect(@product.properties.*.name_en.uniq[0..15]).to eql ["Hard drive capacity", "Aspect ratio",
        "Processor model", "Weight", "Internal memory type", "Hard drive speed", "Wi-Fi standards",
        "Battery technology", "Pointing device", "Audio system", "Operating altitude", "Memory slots",
        "Operating relative humidity (H-H)", "Compatible memory cards", "Storage temperature (T-T)", "Form factor"]

      expect(@product.properties.*.datatype.uniq).to eql ["numeric", "textual", "flag"]
    end

    it "creates values" do
      @metadatum.update_product
      expect(@product.values.*.title_de.uniq).to eql ["Notebook", "Black,Silver", "Clamshell", nil,
        "Intel Core i3-5xxx", "i3-5010U", "BGA1168", "L3", "32-bit,64-bit", "F0", "DMI2",
        "Broadwell", "Intel Core i3-5000 Mobile series", "2x4,4x1", "DDR3L-SDRAM,LPDDR3-SDRAM",
        "1333,1600", "Dual", "DDR3L-SDRAM", "1 x 4", "2x SO-DIMM", "SO-DIMM", "HDD", "Serial ATA",
        "SD,SDHC,SDXC", "1366 x 768", "Matt", "16:9", "Intel HD Graphics 5500",
        "DisplayPort,Embedded DisplayPort (eDP),HDMI", "0x1616", "DTS Sound+",
        "802.11a,802.11ac,802.11b,802.11g,802.11n", "10,100,1000", "Touchpad",
        "Windows 7 Professional", "64-bit", "Windows 8.1 Pro", "AVX 2.0,SSE4.1,SSE4.2", "SR23Z",
        "1.00", "0.00", "Lithium-Ion (Li-Ion)", "50/60", "100 - 240", "0 - 35", "-20 - 60",
        "10 - 90", "5 - 95", "-15.24 - 3048", "-15.24 - 12192", "VT-d,VT-x"]

      expect(@product.values.*.title_en.uniq).to eql ["Notebook", "Black,Silver", "Clamshell", nil,
        "Intel Core i3-5xxx", "i3-5010U", "BGA1168", "L3", "32-bit,64-bit", "F0", "DMI2",
        "Broadwell", "Intel Core i3-5000 Mobile series", "2x4,4x1", "DDR3L-SDRAM,LPDDR3-SDRAM",
        "1333,1600", "Dual", "DDR3L-SDRAM", "1 x 4", "2x SO-DIMM", "SO-DIMM", "HDD", "Serial ATA",
        "SD,SDHC,SDXC", "1366 x 768", "Matt", "16:9", "Intel HD Graphics 5500",
        "DisplayPort,Embedded DisplayPort (eDP),HDMI", "0x1616", "DTS Sound+",
        "802.11a,802.11ac,802.11b,802.11g,802.11n", "10,100,1000", "Touchpad",
        "Windows 7 Professional", "64-bit", "Windows 8.1 Pro", "AVX 2.0,SSE4.1,SSE4.2", "SR23Z",
        "1.00", "0.00", "Lithium-Ion (Li-Ion)", "50/60", "100 - 240", "0 - 35", "-20 - 60",
        "10 - 90", "5 - 95", "-15.24 - 3048", "-15.24 - 12192", "VT-d,VT-x"]

      expect(@product.values.*.unit_de.uniq).to eql ["văn bản", "GHz", "GT/s", "MB", "nm", "W", nil,
        "°C", "MHz", "GB", "GB/s", "RPM", "\"", "Pixel", "Mbit/s", "mm", "Wh", "h", "Hz", "V", "g",
        "%", "m", "G"]

      expect(@product.values.*.unit_en.uniq).to eql [nil, "GHz", "GT/s", "MB", "nm", "W", "°C",
        "MHz", "GB", "GB/s", "RPM", "\"", "pixels", "Mbit/s", "mm", "Wh", "h", "Hz", "V", "g", "%",
        "m", "G"]

      expect(@product.values.*.amount.*.to_s.uniq).to eql ["", "2.1", "2.0", "4.0", "5.0", "3.0",
        "14.0", "15.0", "12.0", "105.0", "600.0", "16.0", "25.6", "1600.0", "500.0", "1.0",
        "5400.0", "2.5", "13.3", "300.0", "900.0", "11.2", "40.0", "45.0", "19.5", "1500.0",
        "326.0", "233.5", "20.0", "21.0", "95.0", "26.5", "200.0", "0.75", "1.5"]

      expect(@product.values.*.flag.uniq).to eql [nil, false, true]
    end
  end


  describe "update_product_relations" do
    before :each do
      @product = create(:product, number: "HP-C8S57A")
      @metadatum = create(:metadatum, product_id: @product.id,
                                      path: "export/freexml.int/INT/19886543.xml",
                                      cat_id: "210",
                                      icecat_model_name: "MSA 2040 SAS Dual Controller Bundle",
                                      supplier_id: "1",
                                      icecat_product_id: "19886543",
                                      prod_id: "C8S57A" )
      FileUtils.copy(Rails.root.join("spec", "support", "19886543.xml"),
                     Rails.root.join("vendor", "xml", "19886543.xml"))

      @related_product = create(:product, number: "HP-AJ941A")
      @related_metadatum = create(:metadatum, product_id: @related_product.id,
                                              path: "export/freexml.int/INT/3637150.xml",
                                              cat_id: "210",
                                              icecat_model_name: "AJ941A",
                                              supplier_id: "1",
                                              icecat_product_id: "3637150",
                                              prod_id: "AJ941A")
      FileUtils.copy(Rails.root.join("spec", "support", "3637150.xml"),
                     Rails.root.join("vendor", "xml", "3637150.xml"))

      @supply = create(:product, number: "HP-614988-B21")
      @supply_metadatum = create(:metadatum, product_id: @supply.id,
                                             path: "export/freexml.int/INT/5123007.xml",
                                             cat_id: "182",
                                             icecat_model_name: "Modular Smart Array SC08e 2-ports Ext PCIe x8 SAS Host Bus Adapter",
                                             supplier_id: "1",
                                             icecat_product_id: "5123007",
                                             prod_id: "614988-B21")
      FileUtils.copy(Rails.root.join("spec", "support", "5123007.xml"),
                     Rails.root.join("vendor", "xml", "5123007.xml"))
    end

    after :each do
      @filename = Rails.root.join("vendor", "xml", "19886543.xml")
      File.delete(@filename) if File.exist?(@filename)

      @filename = Rails.root.join("vendor", "xml", "3637150.xml")
      File.delete(@filename) if File.exist?(@filename)

      @filename = Rails.root.join("vendor", "xml", "5123007.xml")
      File.delete(@filename) if File.exist?(@filename)
    end

    it "creates the Productrelations if cat id is identical" do
      @metadatum.update_product_relations
      expect(@product.related_products.first).to eql @related_product
    end

    it "creates the Supplyrelations if cat id is different" do
      @metadatum.update_product_relations
      expect(@product.supplies.first).to eql @supply
    end
  end


  describe "import_missing_image" do
    before :each do
      @product = create(:product, alternative_number: "D9190B",
                                  photo: nil)
      @metadatum = create(:metadatum, product_id: @product.id)
      @metadatum.download(overwrite: true)
    end

    after :each do
      @filename = Rails.root.join("vendor", "xml", "1286.xml")
      File.delete(@filename) if File.exist?(@filename)
    end

    it "loads a missing image" do
      @metadatum.import_missing_image
      @product.reload
      expect(@product.photo_file_name).to eql "1286.jpg"
      expect(@product.photo_content_type).to eql "image/jpeg"
      expect(@product.photo_file_size).to eql 4121
      expect(Time.now - @product.photo_updated_at < 5.seconds).to eql true
    end
  end
end