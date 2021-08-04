require_relative 'config_helpers'

module Mock
  module Client
    class Exotel < Grape::API
      helpers ConfigHelpers

      desc 'Dumps status to a file. Which can be used later to validate'
      post '/status/index' do
        data = params
        filename_part = params[:CallSid] || "no-sid-#{Time.now}"
        File.open("./callback_json/#{filename_part}.json","w") {|f| f.puts data.to_json}
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

    end
  end
end
