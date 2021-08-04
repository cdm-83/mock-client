require 'json'

module Mock
  module Client
    module ConfigHelpers
      def config end_point
        @end_points_config ||= JSON.parse(File.read("config/end_points.json"))
        end_point_config = @end_points_config.select do |a|
          a["endpoint"] == end_point
        end.first
        if end_point_config
          end_point_config["keys"]
        else
          {}
        end
      end
    end
  end
end
