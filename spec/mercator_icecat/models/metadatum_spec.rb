require 'spec_helper'

describe MercatorIcecat::Metadatum do
  it "is valid with product, path, icecat_updated_at, quality, supplier_id, icecat_product_id," +
     "prod_id, product_number, cat_id, on_market, model_name and product_view" do
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
      expect(@metadatum.model_name).to eql "24uh"
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
      expect(@metadatum.model_name).to eql "24uh"
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
      @metadatum.update_product
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
        762, 1403, 1711, 2686, 2687, 2933, 3024, 4124, 6416, 7946, 8602, 10385, 10674]

      expect(@product.property_groups.*.name_de.uniq).to eql ["optisches Laufwerk", "Bildschirm",
        "Anschlüsse und Schnittstellen", "Prozessor", "Gewicht & Abmessungen", "Energie", "Speicher",
        "Audio", "Tastatur", "Betriebsbedingungen", "Netzwerk", "Sicherheit", "Zertifikate",
        "Software", "Kamera", "Speichermedien", "Verpackungsinformation", "Batterie", "Grafik",
        "Prozessor Besonderheiten", "Design"]

      expect(@product.property_groups.*.name_en.uniq).to eql ["Optical drive", "Display",
        "Ports & interfaces", "Processor", "Weight & dimensions", "Power", "Memory", "Audio",
        "Keyboard", "Operational conditions", "Networking", "Security", "Certificates", "Software",
        "Camera", "Storage", "Packaging data", "Battery", "Graphics", "Processor special features",
        "Design"]

      expect(@product.property_groups.*.position.uniq).to eql [32, 33, 36, 38, 108, 109, 111, 113,
        762, 1404, 1711, 2686, 2687, 2933, 3024, 4128, 6421, 7947, 8602, 10385, 10677]
    end

    it "creates properties" do
      @metadatum.update_product
      expect(@product.properties.*.icecat_id.uniq).to eql [7, 39, 47, 94, 427, 430, 432, 434, 440,
        442, 667, 672, 703, 730, 757, 771, 838, 902, 904, 903, 906, 944, 982, 997, 1006, 1025, 1112,
        1120, 1208, 1230, 1226, 1352, 1347, 1383, 1449, 1452, 1535, 1585, 1637, 1649, 1650, 1766,
        1851, 1926, 2183, 2196, 2262, 2308, 2312, 2314, 2315, 2316, 2321, 2322, 2319, 2323, 2325,
        2905, 2900, 2965, 3233, 3239, 3335, 3336, 3318, 3319, 3374, 3548, 3574, 3566, 3768, 3965,
        3981, 4007, 4023, 4143, 4963, 5702, 5703, 6089, 6220, 6644, 6768, 6784, 6975, 7337, 7563,
        7599, 7617, 7696, 7772, 8421, 8519, 9016, 9018, 9665, 9668, 9670, 9671, 9672, 9733, 9858,
        10041, 10111, 10195, 10198, 11185, 11380, 11381, 11379, 11441, 11779, 12436, 13992, 13995,
        13996, 14052, 14445, 14447, 16921, 17029]

      expect(@product.properties.*.position.uniq).to eql [7, 39, 49, 94, 430, 432, 433, 435, 442,
        446, 667, 681, 704, 738, 759, 786, 838, 907, 909, 910, 914, 958, 999, 1007, 1017, 1039,
        1116, 1137, 1222, 1235, 1237, 1359, 1365, 1385, 1450, 1483, 1549, 1612, 1638, 1658, 1659,
        1807, 1878, 1960, 2209, 2239, 2292, 2331, 2335, 2337, 2338, 2339, 2344, 2345, 2348, 2353,
        2377, 2947, 2952, 2966, 3254, 3276, 3336, 3338, 3373, 3374, 3425, 3577, 3589, 3602, 3808,
        3977, 3993, 4018, 4035, 4179, 5020, 5718, 5719, 6164, 6250, 6696, 6814, 6846, 7054, 7417,
        7594, 7661, 7693, 7772, 7806, 8454, 8547, 9080, 9082, 9696, 9700, 9701, 9702, 9703, 9764,
        9908, 10136, 10148, 10226, 10230, 11226, 11476, 11480, 11486, 11532, 11812, 12507, 14008,
        14012, 14014, 14168, 14498, 14500, 16995, 17115]

      expect(@product.properties.*.name_de.uniq[0..19]).to eql ["Festplattenkapazität", "Seitenverhältnis",
        "Prozessor", "Gewicht", "Interner Speichertyp", "Festplatten-Drehzahl", "WLAN-Standards",
        "Batterietechnologie", "Eingabegerät", "Audio Chip", "Höhe bei Betrieb", "Speichersteckplätze",
        "Luftfeuchtigkeit in Betrieb", "Kompatible Speicherkarten", "Temperaturbereich bei Lagerung",
        "Formfaktor", "Energy Star-zertifiziert", "Netzteil Eingansgsspannung", "Netzteil Ausgangsspannung",
        "Netzteilfrequenz"]

      expect(@product.properties.*.name_en.uniq[0..15]).to eql ["Hard drive capacity", "Aspect ratio",
        "Processor model", "Weight", "Internal memory type", "Hard drive speed", "Wi-Fi standards",
        "Battery technology", "Pointing device", "Audio system", "Operating altitude", "Memory slots",
        "Operating relative humidity (H-H)", "Compatible memory cards", "Storage temperature (T-T)", "Form factor"]

      expect(@product.properties.*.datatype.uniq).to eql ["numeric", "textual", "flag"]
    end

    it "creates values" do
      @metadatum.update_product
      expect(@product.values.*.title_de.uniq).to eql ["Notebook", "Black, Silver", "Clamshell",
        nil, "Intel Core i3-5xxx", "i3-5010U", "BGA1168", "DDR3L-SDRAM", "1 x 4", "2x SO-DIMM",
        "SO-DIMM", "HDD", "Serial ATA", "SD, SDHC, SDXC", "1366 x 768", "Matt", "16:9",
        "Intel HD Graphics 5500", "DTS Sound+", "802.11a, 802.11ac, 802.11b, 802.11g, 802.11n",
        "10, 100, 1000", "Touchpad", "Windows 7 Professional", "64-bit", "Windows 8.1 Pro",
        "Intel Clear Video HD, Intel Insider, Intel InTru 3D, Intel Quick Sync Video", "VT-d, VT-x",
        "Lithium-Ion (Li-Ion)", "50/60", "100 - 240", "0 - 35", "-20 - 60", "10 - 90", "5 - 95",
        "-15.24 - 3048", "-15.24 - 12192"]

      expect(@product.values.*.title_en.uniq).to eql ["Notebook", "Black, Silver", "Clamshell",
        nil, "Intel Core i3-5xxx", "i3-5010U", "BGA1168", "DDR3L-SDRAM", "1 x 4", "2x SO-DIMM",
        "SO-DIMM", "HDD", "Serial ATA", "SD, SDHC, SDXC", "1366 x 768", "Matt", "16:9",
        "Intel HD Graphics 5500", "DTS Sound+", "802.11a, 802.11ac, 802.11b, 802.11g, 802.11n",
        "10, 100, 1000", "Touchpad", "Windows 7 Professional", "64-bit", "Windows 8.1 Pro",
        "Intel Clear Video HD, Intel Insider, Intel InTru 3D, Intel Quick Sync Video", "VT-d, VT-x",
        "Lithium-Ion (Li-Ion)", "50/60", "100 - 240", "0 - 35", "-20 - 60", "10 - 90", "5 - 95",
        "-15.24 - 3048", "-15.24 - 12192"]

      expect(@product.values.*.unit_de.uniq).to eql [nil, "GHz", "GT/s", "MB", "GB", "MHz", "RPM",
        "\"", "pixels", "Mbit/s", "Wh", "h", "W", "Hz", "V", "g", "mm", "°C", "%", "m", "G"]

      expect(@product.values.*.unit_en.uniq).to eql [nil, "GHz", "GT/s", "MB", "GB", "MHz", "RPM",
        "\"", "pixels", "Mbit/s", "Wh", "h", "W", "Hz", "V", "g", "mm", "°C", "%", "m", "G"]

      expect(@product.values.*.amount.*.to_s.uniq).to eql ["", "2.1", "2.0", "4.0", "5.0", "3.0",
        "1600.0", "16.0", "500.0", "1.0", "5400.0", "2.5", "13.3", "40.0", "45.0", "19.5",
        "1500.0", "326.0", "233.5", "20.0", "21.0", "95.0", "26.5", "200.0", "0.75", "1.5"]

      expect(@product.values.*.flag.uniq).to eql [nil, true, false]
    end
  end


  describe "update_product_relations" do
    before :each do
      @product = create(:product, number: "HP-C8S57A")
      @metadatum = create(:metadatum, product_id: @product.id,
                                      path: "export/freexml.int/INT/19886543.xml",
                                      cat_id: "210",
                                      model_name: "MSA 2040 SAS Dual Controller Bundle",
                                      supplier_id: "1",
                                      icecat_product_id: "19886543",
                                      prod_id: "C8S57A" )
      @metadatum.download(overwrite: true)

      @related_product = create(:product, number: "HP-AJ941A")
      @related_metadatum = create(:metadatum, product_id: @related_product.id,
                                              path: "export/freexml.int/INT/3637150.xml",
                                              cat_id: "210",
                                              model_name: "AJ941A",
                                              supplier_id: "1",
                                              icecat_product_id: "3637150",
                                              prod_id: "AJ941A")
      @related_metadatum.download(overwrite: true)

      @supply = create(:product, number: "HP-614988-B21")
      @supply_metadatum = create(:metadatum, product_id: @supply.id,
                                             path: "export/freexml.int/INT/5123007.xml",
                                             cat_id: "182",
                                             model_name: "Modular Smart Array SC08e 2-ports Ext PCIe x8 SAS Host Bus Adapter",
                                             supplier_id: "1",
                                             icecat_product_id: "5123007",
                                             prod_id: "614988-B21")
      @supply_metadatum.download(overwrite: true)
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

    it "creates the Supplyrelations if cat id is different", focus: true do
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