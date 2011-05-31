require "mogilefs"

class MogilefsController < ApplicationController

  def get
    parse_yaml_config unless @hosts
    mg = MogileFS::MogileFS.new(:domain => @domain, :hosts =>  @hosts )
    data = mg.get_file_data "/" + params[:key]
    send_data(data, :filename => params[:key], :type => "default")
  end

  private

  def parse_yaml_config(file_or_path = "config/mogilefs.yml")
    options = 
          case file_or_path
          when File
            YAML::load(ERB.new(File.read(file_or_path.path)).result)
          when String, Pathname
            YAML::load(ERB.new(File.read(file_or_path)).result)
          else
            raise ArgumentError, "Argument is not a path or file"
          end
    options.symbolize_keys!
    @domain = options[:domain]
    @hosts = options[:hosts]
  end

end

