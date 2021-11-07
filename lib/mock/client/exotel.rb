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
      data = params
      filename_part = "connect_applet" || "no-sid-#{Time.now}"
      File.open("./callback_json/#{filename_part}.json","a+") {|f| f.puts data.to_json}
      @@b=params[:from_number].split(',').length
      if @@c<@@b
      @@c+=1
      end
      if @@c>=@@b
       @@c=0
      end
         {
          "from_number": params[:from_number],
          "content-type": "text/plain"
         }
      end
      
      @@c=-1
      @@b=0
      desc 'Programmable Connect API'
      get '/programmable_connect' do
      
      data = params
      filename_part = "programmable_connect" || "no-sid-#{Time.now}"
      File.open("./callback_json/#{filename_part}.json","a+") {|f| f.puts data.to_json}
      @@b=params[:numbers].split(',').length
      if @@c<@@b
      @@c+=1
      end
      if @@c>=@@b
       @@c=0
      end
        {
          "fetch_after_attempt": params[:fetch_after_attempt],
          "destination": {
            "numbers": [params[:numbers].split(',')[@@c]]
          },
          "outgoing_phone_number": params[:outgoing_phone_number],
          "record": params[:record],
          "recording_channels": params[:recording_channels],
          "max_ringing_duration":  params[:max_ringing_duration],
          "max_conversation_duration": params[:max_conversation_duration],
          "music_on_hold": {
            "type": params[:music_on_hold_text],
            "value": params[:music_on_hold_value]
          },
          "start_call_playback": {
            "type": params[:start_call_playback_text],
            "value": params[:start_call_playback_value]
          },
          "parallel_ringing": {
           "activate": params[:parallel_ringing_activate],
           "max_parallel_attempts": params[:max_parallel_attempts]
          },
          "dial_passthru_event_url": params[:dial_passthru_event_url]
        }
	
   
      end
      
      desc 'Gather Applet'
      get '/gather_applet' do
      
      data = params
      filename_part = "gather_applet" || "no-sid-#{Time.now}"
      File.open("./callback_json/#{filename_part}.json","a+") {|f| f.puts data.to_json}
       {
        "gather_prompt": {
            "text":  params[:gather_prompt_text]
          },
        "max_input_digits":  params[:max_input_digits],
        "finish_on_key": params[:finish_on_key],
        "input_timeout": params[:input_timeout],
        "repeat_menu": params[:repeat_menu],
        "repeat_gather_prompt": {
            "text":  params[:repeat_gather_prompt_text]
          }
        }
      end
      
      desc 'Pass  through code for different status code'
      get '/passthru_applet' do
      	 data = params
         filename_part = "passthru_applet" || "no-sid-#{Time.now}"
         File.open("./callback_json/#{filename_part}.json","a+") {|f| f.puts data.to_json}
	 params[:status]
	 
	   
      end
      
      desc 'Pass  through code for different status code'      
      get '/passthru' do        
         data = params
         filename_part = "passthru_applet" || "no-sid-#{Time.now}"
         File.open("./callback_json/#{filename_part}.json","a+") {|f| f.puts data.to_json}
         status = params[:status]
          if status == "200"
             status config("passthru_200")["status"]
          elsif status == "302"
            status config("passthru_302")["status"]
          elsif status == "404"
            status config("passthru_404")["status"]
          elsif status == "500"
            status config("passthru_500")["status"]
          else
             status config("passthru_200")["status"]
          end
      end
      
      desc 'Pass  through switch case applet'      
      get '/passthru_switch_case' do        
         data = params
         filename_part = "passthru_applet" || "no-sid-#{Time.now}"
         File.open("./callback_json/#{filename_part}.json","a+") {|f| f.puts data.to_json}
         {
          "select": params[:select],
          "content-type": "text/plain"
         } 
          
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
