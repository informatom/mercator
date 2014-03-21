module IvellioOrderHelper

  def prepare_mesonic_order( order )
    returning( order ) do |o|
      if current_customer
        mesonic_account = current_customer.mesonic_account
        kontenstamm_adresse = current_customer.mesonic_kontenstamm_adresse
        kontenstamm = current_customer.mesonic_kontenstamm

        o.billing_name = kontenstamm.name
        o.billing_to_hand = kontenstamm_adresse.to_hand
        o.billing_street = kontenstamm_adresse.street
        o.billing_postal = kontenstamm_adresse.postal
        o.billing_city = kontenstamm_adresse.city
        o.billing_state_code = kontenstamm_adresse.land
	    o.billing_name2 = kontenstamm.c084

        o.shipping_name = kontenstamm.name
        o.shipping_to_hand = kontenstamm_adresse.to_hand
        o.shipping_street = kontenstamm_adresse.street
        o.shipping_postal = kontenstamm_adresse.postal
        o.shipping_city = kontenstamm_adresse.city
        o.shipping_state_code = kontenstamm_adresse.land
      end
    end
  end
end