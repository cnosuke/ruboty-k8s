require 'yaml'
require 'erb'

class Ruboty::K8s::Config
  class << self
    def client(cluster_name)
      config_yml[cluster_name]['client']
    end

    def deployments(cluster_name)
      config_yml[cluster_name]['deployments']
    end

    def has_cluster?(cluster_name)
      config_yml.keys.include?(cluster_name)
    end

    def config_yml
      @@config_yml ||= begin
        YAML.load(
          ERB.new(
            open(config_file_path).read
          ).result
        )
      end
    end

    def config_file_path
      @@config_file_path ||= ENV['RUBOTY_K8S_CONFIG_PATH']
    end

    def set_config_file_path(file_path)
      @@config_file_path = file_path
    end
  end
end
