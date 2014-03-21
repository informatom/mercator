namespace :accounts do

  desc "sync web accounts from mesonic webedition (WT003) with opensteam"
  task :sync_old_webaccounts => :environment do
      i = IvellioVellin::Customer.new(
        :name =>  Iconv.conv('utf8', 'ISO-8859-1', [ mesonic_account.c002, mesonic_account.c001 ].join(" ") ),
        :email => email,
        :password => password,
        :password_confirmation => password,
        :agb => "1"
      )
      puts i.save

      i.account_number = mesonic_account_number
      i.mesonic_account_id = mesonic_contact_number
      i.mesonic_account_mesoprim = mesonic_contact_mesoprim
      i.account_number_mesoprim = mesonic_account_mesoprim
    end
  end
end