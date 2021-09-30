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
    
  end
  
end
