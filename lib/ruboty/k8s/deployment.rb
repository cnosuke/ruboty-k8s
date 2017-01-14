class Ruboty::K8s::Deployment
  def initialize(config, client)
    @config = config
    @client = client
  end

  def has_deployment?(deployment)
    @config.keys.include?(deployment)
  end

  def rollback_deployment(deployment)
    raise "Unknown deployment name: `#{deployment}`" unless has_deployment?(deployment)

    response = @client.v1beta1.rollback_deployment(
      @config[deployment]['deployment_name'], {}, @config[deployment]['namespace']
    )

    response.code == 201
  end

  def patch_deployment(deployment, image)
    raise "Unknown deployment name: `#{deployment}`" unless has_deployment?(deployment)

    response = @client.v1beta1.patch_deployment(
      @config[deployment]['deployment_name'],
      patch_deployment_params(deployment, image),
      @config[deployment]['namespace']
    )

    response.code == 200
  end

  def patch_deployment_params(deployment, image)
    {
      spec: {
        template: {
          spec: {
            containers: [
              {
                name: @config[deployment]['container_name'],
                image: image,
              }
            ]
          }
        }
      }
    }
  end
end
