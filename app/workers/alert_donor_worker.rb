class AlertDonorWorker
  include Sidekiq::Worker

  def perform(user_id,request_id, request_description)
    # Do something later
    bloods = {"A+" => ["A-","O-","+"],
      "A-" => ["O-"],
      "B+"=> ["B-","O+","O-"],
      "B-"=> ["O-"],
      "AB+"=> ["A-","A+","AB-","B+","B-","O+","O-"],
      "AB-"=> ["A-","B-","O-"],
      "O+"=> ["O-"],
    }
    blood_compatible = bloods[request_description]
    donors = Donor.all
    donors.each do |donor|
      if((blood_compatible.include?(donor.blood) || donor.blood==request_description) && user_id != donor.user_id)
        RequestMailer.with(user: donor.user_id, request: request_id, donor: donor.id).to_donor_with_same_type.deliver_now
      end
    end
  end
  
end
