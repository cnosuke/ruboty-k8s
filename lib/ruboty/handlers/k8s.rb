require 'ruboty/k8s'

module Ruboty
  module Handlers
    class K8s < Base
      on /k8s deploy (?<cluster_name>.+) (?<deployment_name>.+) (?<container_image>.+)/,
        name: 'deployment',
        description: 'Update K8s `deployment` object.'

      on /k8s rollback (?<cluster_name>.+) (?<deployment_name>.+)/,
        name: 'rollback',
        description: 'Rollback `deployment` object.'

      def deployment(m = {})
        @deployments = setup(m)
        return false unless @deployments

        res = @deployments.patch_deployment(m[:deployment_name], m[:container_image])

        if res
          m.reply("Patched: #{m[:deployment_name]}(#{m[:cluster_name]}) -> #{m[:container_image]}")
        else
          m.reply("Failed :cry:")
        end
      end

      def rollback(m = {})
        @deployments = setup(m)
        return false unless @deployments

        res = @deployments.rollback_deployment(m[:deployment_name])

        if res
          m.reply("Rollbacked: #{m[:deployment_name]}(#{m[:cluster_name]})")
        else
          m.reply("Failed :cry:")
        end
      end

      def setup(m)
        cluster_name = m[:cluster_name]

        unless Ruboty::K8s::Config.has_cluster?(cluster_name)
          m.reply("ERROR: Unknown cluster name: `#{cluster_name}` :sob:")
          return false
        end

        client_config = Ruboty::K8s::Config.client(cluster_name)
        deployment_config = Ruboty::K8s::Config.deployments(cluster_name)
        client = Ruboty::K8s::Client.new(client_config)
        @deployments = Ruboty::K8s::Deployment.new(deployment_config, client)

        unless @deployments.has_deployment?(m[:deployment_name])
          m.reply("ERROR: Unknown deployment name: `#{m[:deployment_name]}` :sob:")
          return false
        end

        return @deployments
      end
    end
  end
end
