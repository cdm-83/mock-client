require_relative 'config_helpers'

module Mock
  module Client
    class Exotel < Grape::API
      helpers ConfigHelpers

      desc 'Dumps status to a file. Which can be used later to validate'
        post '/status_callback' do
        data = params
        filename_part = params[:CallSid] || "no-sid-#{Time.now}"
        File.open("./callback_json/#{filename_part}.json","a+") {|f| f.puts data.to_json}
        params
      end

      desc 'Gather API'
      get '/gather/:callSID' do
        {
          "gather_prompt": {
            "text": "Hello Kovalan, please provide your order id",
          },
          "callSID": params[:callSID],
          "from_number": params[:from_number],
          "max_recording_time": config("gather")["record_time"],
          "finish_on_key": "#",
          "input_timeout": 6,
          "repeat_menu": 2,
          "repeat_gather_prompt": {
            "text": "It seems that you have not provided any input, please try again."
          }
        }
      end
      
      @@c=-1
      @@b=0
      desc 'Connect API'
      get '/connect' do
      @@b=params[:from_number].split(',').length
      if @@c<@@b
      @@c+=1
      end
      if @@c>=@@b
       @@c=0
      end
         {
          "from_number": params[:from_number].split(',')[@@c],
          "content-type": "text/plain"
         }
      end
      
      @@c=-1
      @@b=0
      desc 'Programmable Connect API'
      get '/programmable_connect' do
      @@b=params[:destination_numbers].split(',').length
      if @@c<@@b
      @@c+=1
      end
      if @@c>=@@b
       @@c=0
      end
        {
          "fetch_after_attempt": params[:fetch_after_attempt],
          "destination": {
            "numbers": [params[:destination_numbers].split(',')[@@c]]
          },
          "outgoing_phone_number": params[:outgoing_phone_number],
          "record": "true",
          "recording_channels": "dual",
          "max_ringing_duration": config("programmable_connect")["max_ringing"],
          "max_conversation_duration": config("programmable_connect")["max_conversation"],
          "music_on_hold": {
            "type": "operator_tone"
          },
          "start_call_playback": {
            "type": "text",
            "value": "This text would be spoken out to the callee"
          },
          "parallel_ringing": {
           "activate": true,
           "max_parallel_attempts": params[:max_parallel_attempts]
          },
          "dial_passthru_event_url": params[:dial_passthru_event_url]
        }
      end
      
      desc 'Gather Applet'
      get '/gather_applet' do
       {
        "gather_prompt": {
            "text": "Please enter your mobile number",
          },
        "max_input_digits": 10,
        "finish_on_key": "#",
        "input_timeout": 6,
        "repeat_menu": 2,
        "repeat_gather_prompt": {
            "text": "It seems that you have not provided any input, please try again."
          }
        }
      end

      desc 'Pass  through'
      get '/pass_through' do
        {
          "gather_prompt": {
            "text": "Please enter your mobile number",
          },
          "status": params[:from_number],
        }
        status config("pass_through")["status"]
      end

      desc 'Dumps status to a file. Which can be used later to validate'
      get '/callback_response_url' do
        puts params.inspect
        data = params
        filename_part = params[:CallSid]  || "no-sid-#{Time.now}"
        File.open("./callback_json/#{filename_part}.json","a+") {|f| f.puts data.to_json}
        params
      end
      
      desc 'Dumps status to a file. Which can be used later to validate'
      get '/response_data_url' do
        data = params
        filename_part = params[:filename]  || "no-sid-#{Time.now}"
        File.open("./callback_json/#{filename_part}.json","a+") {|f| f.puts data.to_json}
        params
      end
      
      desc 'truncate the data in the file'
      post '/truncate_response_data' do
        filename_part = params[:filename]  || "no-sid-#{Time.now}"
        File.open("./callback_json/#{filename_part}.json","w+") {|file| file.truncate(0) }
        params
      end
    end
  end
end
