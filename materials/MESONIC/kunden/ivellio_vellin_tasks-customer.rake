namespace :ivellio do

  namespace :customers do
    desc "Update mesoprim for all Ivellio-Vellin Customers in Opensteam Database"
    task :update_mesoprim => :environment do
      customers = ::IvellioVellin::Customer
      i = customers.count
      j = 1

      mesocomp = Mesonic::AktMandant.mesocomp
      mesoyear = Mesonic::AktMandant.mesoyear

      RAILS_DEFAULT_LOGGER.info("[OPENSTEAM] update mesoprim for customers started")
      customers.all.each do |customer|
        account_number_mesoprim = [ customer.account_number, mesocomp, mesoyear ].join("-")
        mesonic_account_mesoprim = [ customer.mesonic_account_id, mesocomp, mesoyear ].join("-")
        RAILS_DEFAULT_LOGGER.info("[OPENSTEAM] updating customer #{customer.id} (#{j}/#{i})")
        customer.mesonic_account_mesoprim = mesonic_account_mesoprim
        customer.account_number_mesoprim = account_number_mesoprim
        customer.save
        j += 1
      end
      RAILS_DEFAULT_LOGGER.info("[OPENSTEAM] update mesoprim for customers finished")
    end
  end
end